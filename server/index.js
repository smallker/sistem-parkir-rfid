const tarif = 4000
var express = require('express')
var path = require('path')
var app = express()
var cors = require('cors')
var bodyParser = require('body-parser')
const cron = require('node-cron');
var ip = require('ip');
var mysql = require('mysql')
var db = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "sistem_parkir"
});
db.connect((err) => {
    if (err) throw err
    console.log('koneksi database berhasil')
})
app.use(cors())
app.use(bodyParser.json())
app.use(express.static(path.join(__dirname, '../web/build/web')))
app.use(express.urlencoded({ extended: true }))
app.get('/', (req, res) => {
    res.render('index')
})

app.get('/userinfo', (req, res) => {
    let rfid = req.query.rfid
    db.query(`SELECT * from userinfo where rfid = ${rfid}`, (err, rows, field) => {
        try {
            if (rows[0] != null) {
                res.send(rows[0])
            }
            else
                res.status(404).send('na')

        } catch (error) {
            res.status(404).send('na')
        }
    })
})

app.get('/entry', (req, res) => {
    let now = Date.now()
    let rfid = req.query.rfid
    db.query(`SELECT * from userinfo where rfid = ${rfid}`, (err, rows, field) => {
        try {
            if (rows[0] != null)
                db.query(`UPDATE userinfo set last_entry = ${now}`, (err, rows, field) => {
                    res.send('ok')
                })
            else
                res.status(404).send('na')

        } catch (error) {
            res.status(404).send('na')
        }
    })
})

app.get('/exit', (req, res) => {
    
    let now = Date.now()
    let rfid = req.query.rfid
    db.query(`SELECT * from userinfo where rfid = ${rfid}`, (err, rows, field) => {
        try {
            if (rows[0] != null){
                let charge = Math.round(((now - rows[0].last_entry) / (3600*1000)) * tarif)
                db.query(`UPDATE userinfo set balance = balance - ${charge}`, (err, rows, field) => {
                    res.send('ok')
                })
            }
            else
                res.status(404).send('na')

        } catch (error) {
            res.status(404).send('na')
        }
    })
})

app.post('/recharge', (req, res) => {
    let rfid = req.body.rfid
    let balance = req.body.balance
    db.query(`SELECT * from userinfo where rfid = ${rfid}`, (err, rows, field) => {
        try {
            if (rows[0] != null) {
                db.query(`UPDATE userinfo set balance=balance+${balance} where rfid = ${rfid}`, (err, rows, field) => {
                    res.send('OK')
                })
            }
            else
                res.status(404).send('na')

        } catch (error) {
            res.status(404).send('na')
        }
    })
})

app.post('/create', (req, res) => {
    let rfid = req.body.rfid
    let name = req.body.name
    db.query(`SELECT * from userinfo where rfid = ${rfid}`, (err, rows, field) => {
        if (rows[0] != null) {
            res.send('na')
        }
        else
            db.query(`INSERT INTO userinfo (rfid, name, balance, last_login, is_login) values ('${rfid}','${name}',0,0,0)`, (err, rows, field) => {
                res.send('ok')
            })

    })
})

app.listen(3000, console.log(`Web Server : ${ip.address()}:3000`))