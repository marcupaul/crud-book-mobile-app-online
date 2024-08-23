var koa = require('koa');
var app = module.exports = new koa();
const server = require('http').createServer(app.callback());
const WebSocket = require('ws');
const wss = new WebSocket.Server({server});
const Router = require('koa-router');
const cors = require('@koa/cors');
const bodyParser = require('koa-bodyparser');

app.use(bodyParser());

app.use(cors());

app.use(middleware);

function middleware(ctx, next) {
  const start = new Date();
  return next().then(() => {
    const ms = new Date() - start;
    console.log(`${start.toLocaleTimeString()} ${ctx.request.method} ${ctx.request.url} - ${ms}ms`);
  });
}

var books = [{
  "id": 1,
  "title": "Moby Dick",
  "author": "Herman Melville",
  "publishingDate": "1851",
  "isbn": "9780672609718",
  "description": "The saga of Captain Ahab and his monomaniacal pursuit of the white whale remains a peerless adventure story but one full of mythic grandeur, poetic majesty, and symbolic power.",
  "path": "https://www.gutenberg.org/files/2701/2701-h/2701-h.htm"
},
{
  "id": 2,
  "title": "Faust, a Tragedy",
  "author": "Johann Wolfgang von Goethe",
  "publishingDate": "1808",
  "isbn": "9780385031141",
  "description": "Goethe’s masterpiece and perhaps the greatest work in German literature, “Faust” has made the legendary German alchemist one of the central myths of the Western world.",
  "path": "https://www.gutenberg.org/files/14591/14591-h/14591-h.htm"
},
{
  "id": 3,
  "title": "Crime and Punishment",
  "author": "Fyodor Dostoevsky",
  "publishingDate": "1866",
  "isbn": "9780198709701",
  "description": "Raskolnikov, an impoverished student tormented by his own nihilism, and the struggle between good and evil, believes he is above the law.",
  "path": "https://www.gutenberg.org/cache/epub/2554/pg2554-images.html"
},
{
  "id": 4,
  "title": "Kabbalah",
  "author": "Gershom Scholem",
  "publishingDate": "1978",
  "isbn": "9780880292054",
  "description": "The body of writings and beliefs known as the Kabbalah has come to be increasingly recognized not only as one of the most intriguing aspects of Judaism but also as an important part of a broader mystical tradition.",
  "path": "https://books.google.ro/books/about/Kabbalah.html?id=qJesQGFsSwsC&redir_esc=y"
}
];

var pk = books.length;

const router = new Router();
router.get('/books', ctx => {
    ctx.response.body = books;
    ctx.response.status = 200;
});

const broadcast = (data) =>
  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(data);
    }
  });

router.post('/book', ctx => {
  const book = ctx.request.body;
  let issue;
  if (!book.title) {
    issue = {title: 'Title cannot be missing.'};
  }
  if (issue) {
    ctx.response.body = issue;
    ctx.response.status = 400;
  } else {
    book.id = ++pk;
    books.push(book);
    ctx.response.body = book;
    ctx.response.status = 201;
    broadcast(JSON.stringify({operation: "post", payload: book}));
  }
});

router.put('/books/:id', ctx => {
  const book = ctx.request.body;
  const ctxId = ctx.params.id;
  let issue;
  if (!book.title) {
    issue = {title: 'Title cannot be missing.'};
  }
  if (issue) {
    ctx.response.body = issue;
    ctx.response.status = 400;
  } else {
    for (var savedBook of books) {
      if (savedBook.id == ctxId) {
        books.splice(books.indexOf(savedBook), 1, book);
      }
    }
    ctx.response.body = book;
    ctx.response.status = 200;
    broadcast(JSON.stringify({operation: "put", payload: book}));
  }
});

router.del('/books/:id', ctx => {
  const ctxId = ctx.params.id;
  var book;
  for (var savedBook of books) {
      if (savedBook.id == ctxId) {
        book = savedBook;
        books.splice(books.indexOf(savedBook), 1);
      }
  }
  book = books.at(books.findIndex(book => book.id == ctxId));
  ctx.response.body = book;
  ctx.response.status = 202;
  broadcast(JSON.stringify({operation: "delete", payload: ctxId}));
});

app.use(router.routes());
app.use(router.allowedMethods());

const port = 3000;

server.listen(port, () =>{
  console.log(`SERVER CURRENTLY RUNNING ON PORT ${port} ...`);
});