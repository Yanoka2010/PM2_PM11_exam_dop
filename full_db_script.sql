CREATE DATABASE book_world;

\c book_world

CREATE TABLE Roles (
    role_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
    hjjhj
);

CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    role_id INTEGER NOT NULL REFERENCES Roles(role_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    full_name VARCHAR(100) NOT NULL,
    login VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE Authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Genres (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Publishers (
    publisher_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Books (
    book_id SERIAL PRIMARY KEY,
    article VARCHAR(10) UNIQUE NOT NULL,
    title VARCHAR(200) NOT NULL,
    author_id INTEGER NOT NULL REFERENCES Authors(author_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    genre_id INTEGER NOT NULL REFERENCES Genres(genre_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    publisher_id INTEGER NOT NULL REFERENCES Publishers(publisher_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    year INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    discount_price DECIMAL(10,2) DEFAULT NULL,
    is_on_sale BOOLEAN DEFAULT FALSE,
    stock INTEGER NOT NULL DEFAULT 0,
    description TEXT,
    cover_path VARCHAR(50) DEFAULT 'picture.png'
);

CREATE TABLE PickupPoints (
    pickup_point_id SERIAL PRIMARY KEY,
    address VARCHAR(200) NOT NULL
);

CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    pickup_point_id INTEGER NOT NULL REFERENCES PickupPoints(pickup_point_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    order_date DATE NOT NULL,
    delivery_date DATE NOT NULL,
    receive_code VARCHAR(10) NOT NULL,
    status VARCHAR(50) NOT NULL
);

CREATE TABLE OrderDetails (
    detail_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES Orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    book_id INTEGER NOT NULL REFERENCES Books(book_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    quantity INTEGER NOT NULL
);\c book_world

INSERT INTO Roles (name) VALUES 
('Administrator'),
('Manager'),
('Client');

INSERT INTO Users (role_id, full_name, login, password) VALUES 
(1, 'Орлова Алина Викторовна', 'a.orlova@bookworld.ru', 'Ah7kLp'),
(1, 'Волков Денис Сергеевич', 'd.volkov@bookworld.ru', 'Bm2qR9'),
(2, 'Семенова Ирина Олеговна', 'i.semenova@bookworld.ru', 'Cn8tWx'),
(2, 'Козлов Максим Игоревич', 'm.kozlov@bookworld.ru', 'Df4yUz'),
(2, 'Николаева Татьяна Петровна', 't.nikolaeva@bookworld.ru', 'Eg6vAs'),
(3, 'Белов Алексей Дмитриевич', 'a.belov@example.com', 'Fh9jQw'),
(3, 'Соколова Мария Андреевна', 'm.sokolova@example.com', 'Gi1kEx'),
(3, 'Морозов Иван Павлович', 'i.morozov@example.com', 'Hj2lFy'),
(3, 'Лебедева Ольга Васильевна', 'o.lebedeva@example.com', 'Kk3mGz');

INSERT INTO Authors (name) VALUES 
('Михаил Булгаков'),
('Джордж Оруэлл'),
('Федор Достоевский'),
('Эрих Мария Ремарк'),
('Антуан де Сент-Экзюпери'),
('Артур Конан Дойл'),
('Джоан Роулинг'),
('Агата Кристи'),
('Лев Толстой'),
('Пауло Коэльо'),
('Оскар Уайльд'),
('Джером Сэлинджер'),
('Орсон Скотт Кард'),
('Дуглас Адамс'),
('Дэниел Киз');

INSERT INTO Genres (name) VALUES 
('Классика'),
('Антиутопия'),
('Детская'),
('Детектив'),
('Фэнтези'),
('Роман'),
('Фантастика'),
('Научная фантастика');

INSERT INTO Publishers (name) VALUES 
('Эксмо'),
('АСТ'),
('Азбука'),
('Махаон'),
('София'),
('Иностранка');

INSERT INTO Books (article, title, author_id, genre_id, publisher_id, year, price, discount_price, is_on_sale, stock, description, cover_path) VALUES 
('B112F4', 'Мастер и Маргарита', 1, 1, 1, 2020, 450.00, 380.00, TRUE, 12, 'Бессмертное произведение русской литературы, полное мистики и философских размышлений.', '1.png'),
('F635R4', '1984', 2, 2, 2, 2019, 520.00, NULL, FALSE, 8, 'Знаменитая антиутопия, рассказывающая о тоталитарном обществе под постоянным контролем.', '2.png'),
('H782T5', 'Преступление и наказание', 3, 1, 1, 2021, 480.00, 430.00, TRUE, 15, 'Глубокий психологический роман о преступлении и моральных муках раскаяния.', '3.png'),
('G783F5', 'Три товарища', 4, 1, 3, 2018, 590.00, NULL, FALSE, 7, 'Трогательная история о дружбе и любви на фоне сложного времени в Германии.', '4.png'),
('J384T6', 'Маленький принц', 5, 3, 4, 2022, 380.00, 340.00, TRUE, 20, 'Философская сказка для детей и взрослых, говорящая о самом важном в жизни.', '5.png'),
('D572U8', 'Шерлок Холмс (сборник)', 6, 4, 1, 2020, 650.00, 590.00, TRUE, 9, 'Знаменитые расследования великого сыщика Шерлока Холмса и его друга доктора Ватсона.', '6.png'),
('F572H7', 'Гарри Поттер и философский камень', 7, 5, 4, 2021, 720.00, NULL, FALSE, 14, 'Первая книга культовой серии о юном волшебнике Гарри Поттере.', '7.png'),
('D329H3', 'Убийство в Восточном экспрессе', 8, 4, 1, 2019, 430.00, 390.00, TRUE, 11, 'Одно из самых известных дел Эркюля Пуаро, разворачивающееся в поезде.', '8.png'),
('B320R5', 'Война и мир (том 1)', 9, 1, 2, 2021, 550.00, NULL, FALSE, 6, 'Монументальный роман-эпопея, охватывающий судьбы людей на фоне войны с Наполеоном.', '9.png'),
('G432E4', 'Алхимик', 10, 6, 5, 2020, 480.00, 430.00, TRUE, 18, 'Притча о юном пастухе Сантьяго, отправившемся на поиски своего сокровища и предназначения.', '10.png'),
('S213E3', 'Портрет Дориана Грея', 11, 1, 1, 2018, 460.00, NULL, FALSE, 5, 'История о красоте, разврате и таинственном портрете, стареющем вместо своего владельца.', 'picture.png'),
('E482R4', 'Над пропастью во ржи', 12, 1, 3, 2019, 390.00, 350.00, TRUE, 10, 'Роман о подростковом бунте и поиске себя в лицемерном взрослом мире.', 'picture.png'),
('S634B5', 'Игра Эндера', 13, 7, 1, 2021, 540.00, NULL, FALSE, 0, 'История одаренного мальчика, готовящегося к защите Земли от инопланетной угрозы.', 'picture.png'),
('K345R4', 'Автостопом по галактике', 14, 7, 2, 2020, 510.00, 460.00, TRUE, 13, 'Юмористическая фантастика о невероятных приключениях землянина Артура Дента.', 'picture.png'),
('O754F4', 'Цветы для Элджернона', 15, 8, 6, 2021, 470.00, 420.00, TRUE, 8, 'Трогательная история человека, участвующего в эксперименте по повышению интеллекта.', 'picture.png');

INSERT INTO PickupPoints (address) VALUES 
('г. Москва, ул. Тверская, д. 10'),
('г. Москва, пр-т Мира, д. 25'),
('г. Санкт-Петербург, Невский пр-т, д. 45'),
('г. Санкт-Петербург, ул. Садовая, д. 12'),
('г. Екатеринбург, ул. Ленина, д. 33'),
('г. Новосибирск, Красный пр-т, д. 20'),
('г. Казань, ул. Баумана, д. 15'),
('г. Нижний Новгород, ул. Большая Покровская, д. 5'),
('г. Ростов-на-Дону, ул. Большая Садовая, д. 8'),
('г. Челябинск, ул. Кирова, д. 78'),
('г. Омск, ул. Ленина, д. 10'),
('г. Самара, ул. Куйбышева, д. 95'),
('г. Уфа, пр-т Октября, д. 25'),
('г. Красноярск, ул. Карла Маркса, д. 48'),
('г. Воронеж, ул. Плехановская, д. 10'),
('г. Пермь, ул. Ленина, д. 35'),
('г. Волгоград, пр-т Ленина, д. 25'),
('г. Краснодар, ул. Красная, д. 100'),
('г. Саратов, ул. Московская, д. 5'),
('г. Тюмень, ул. Республики, д. 50'),
('г. Ижевск, ул. Пушкинская, д. 150'),
('г. Барнаул, ул. Ленина, д. 30'),
('г. Иркутск, ул. Литвинова, д. 16'),
('г. Ульяновск, ул. Гончарова, д. 25'),
('г. Хабаровск, ул. Муравьева-Амурского, д. 5'),
('г. Ярославль, ул. Кирова, д. 10'),
('г. Владивосток, ул. Светланская, д. 25'),
('г. Махачкала, ул. Даниялова, д. 30'),
('г. Томск, пр-т Ленина, д. 50'),
('г. Кемерово, пр-т Советский, д. 35'),
('г. Рязань, ул. Почтовая, д. 45'),
('г. Астрахань, ул. Советская, д. 15'),
('г. Набережные Челны, пр-т Мира, д. 20'),
('г. Пенза, ул. Московская, д. 50'),
('г. Липецк, пр-т Победы, д. 25'),
('г. Киров, ул. Воровского, д. 40');

INSERT INTO Orders (order_id, user_id, pickup_point_id, order_date, delivery_date, receive_code, status) VALUES 
(1001, 6, 3, '2025-02-15', '2025-02-20', 'Z1X9Y2', 'Доставлен'),
(1002, 7, 7, '2025-02-16', '2025-02-21', 'A3B4C5', 'Доставлен'),
(1003, 8, 12, '2025-02-18', '2025-02-23', 'D6E7F8', 'Доставлен'),
(1004, 9, 5, '2025-02-20', '2025-02-25', 'G9H0I1', 'Доставлен'),
(1005, 6, 18, '2025-03-01', '2025-03-06', 'J2K3L4', 'В обработке'),
(1006, 7, 22, '2025-03-02', '2025-03-07', 'M5N6O7', 'В обработке'),
(1007, 8, 9, '2025-03-03', '2025-03-08', 'P8Q9R0', 'В обработке'),
(1008, 9, 31, '2025-03-04', '2025-03-09', 'S1T2U3', 'В обработке'),
(1009, 6, 14, '2025-03-05', '2025-03-10', 'V4W5X6', 'Новый'),
(1010, 7, 27, '2025-03-06', '2025-03-11', 'Y7Z8A9', 'Новый');

INSERT INTO OrderDetails (order_id, book_id, quantity) VALUES 
(1001, 1, 1), (1001, 2, 2),
(1002, 3, 1), (1002, 4, 1),
(1003, 5, 1), (1003, 6, 1),
(1004, 7, 1), (1004, 8, 1),
(1005, 1, 2), (1005, 2, 1),
(1006, 3, 1), (1006, 4, 2),
(1007, 5, 3), (1007, 6, 1),
(1008, 7, 1), (1008, 8, 2),
(1009, 9, 1), (1009, 10, 1),
(1010, 11, 1), (1010, 12, 1);