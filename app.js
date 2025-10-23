const express = require('express');
const { Pool } = require('pg');
const app = express();
const port = 3000;

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'book_world',
  password: 'password',
  port: 5432,
});

app.set('view engine', 'ejs');
app.use(express.static('public'));
app.use(express.urlencoded({ extended: true }));

let current_user = null;

app.get('/', (req, res) => {
  res.render('login', { error: null });
});

app.get('/login', (req, res) => {
  if (req.query.guest === 'true') {
    current_user = { role: 'guest', full_name: 'Гость' };
    console.log('Guest logged in:', current_user);
    res.redirect('/catalog');
  } else {
    res.render('login', { error: null });
  }
});

app.post('/login', async (req, res) => {
  const { login, password } = req.body;
  try {
    const query = 'SELECT u.*, r.name AS role FROM Users u JOIN Roles r ON u.role_id = r.role_id WHERE login = $1 AND password = $2';
    const result = await pool.query(query, [login, password]);
    if (result.rows.length > 0) {
      current_user = result.rows[0];
      console.log('Logged in as:', current_user.full_name, 'with role:', current_user.role);
      res.redirect('/catalog');
    } else {
      res.render('login', { error: 'Неверный логин или пароль' });
    }
  } catch (err) {
    console.error('Login error:', err);
    res.render('login', { error: 'Ошибка авторизации' });
  }
});

app.get('/catalog', async (req, res) => {
  const { search, genre, year_min, year_max, price_min, price_max, sort } = req.query;
  let query = 'SELECT b.*, a.name AS author_name, g.name AS genre_name, p.name AS publisher_name FROM Books b JOIN Authors a ON b.author_id = a.author_id JOIN Genres g ON b.genre_id = g.genre_id JOIN Publishers p ON b.publisher_id = p.publisher_id';
  const params = [];
  let conditions = [];
  if (search && (current_user.role === 'Client' || current_user.role === 'Manager' || current_user.role === 'Administrator')) {
    conditions.push('(b.title ILIKE $1 OR a.name ILIKE $1)');
    params.push(`%${search}%`);
  }
  if (genre && (current_user.role === 'Manager' || current_user.role === 'Administrator')) {
    conditions.push('g.name = $' + (params.length + 1));
    params.push(genre);
  }
  if (year_min && (current_user.role === 'Manager' || current_user.role === 'Administrator')) {
    conditions.push('b.year >= $' + (params.length + 1));
    params.push(year_min);
  }
  if (year_max && (current_user.role === 'Manager' || current_user.role === 'Administrator')) {
    conditions.push('b.year <= $' + (params.length + 1));
    params.push(year_max);
  }
  if (price_min && (current_user.role === 'Manager' || current_user.role === 'Administrator')) {
    conditions.push('b.price >= $' + (params.length + 1));
    params.push(price_min);
  }
  if (price_max && (current_user.role === 'Manager' || current_user.role === 'Administrator')) {
    conditions.push('b.price <= $' + (params.length + 1));
    params.push(price_max);
  }
  if (conditions.length > 0) {
    query += ' WHERE ' + conditions.join(' AND ');
  }
  if (sort && (current_user.role === 'Manager' || current_user.role === 'Administrator')) {
    query += ' ORDER BY ' + (sort === 'price' ? 'b.price' : 'b.title');
  }
  const books = await pool.query(query, params);
  res.render('catalog', { books: books.rows, user: current_user });
});

app.get('/logout', (req, res) => {
  current_user = null;
  res.redirect('/');
});

app.get('/orders', async (req, res) => {
  if (current_user.role !== 'Manager' && current_user.role !== 'Administrator') {
    return res.redirect('/catalog');
  }
  const orders = await pool.query('SELECT o.*, u.full_name FROM Orders o JOIN Users u ON o.user_id = u.user_id');
  res.render('orders', { orders: orders.rows, user: current_user });
});

app.get('/admin', (req, res) => {
  if (current_user.role !== 'Administrator') {
    return res.redirect('/catalog');
  }
  res.render('admin', { user: current_user });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});