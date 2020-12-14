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
    console.log(`info : ${rfid}`)
    db.query(`SELECT * from userinfo where rfid = '${rfid}'`, (err, rows, field) => {
        try {
            if (rows[0] != null)
                res.send(rows[0])
            else res.sendStatus(404)
        } catch (error) {
            console.log(error)
            res.sendStatus(404)
        }
    })
})

app.get('/entry', (req, res) => {
    let now = Date.now()
    let rfid = req.query.rfid
    console.log(rfid)
    db.query(`SELECT * from userinfo where rfid = '${rfid}'`, (err, rows, field) => {
        try {
            if (rows[0] != null) {
                let balance = rows[0].balance
                let islogin = rows[0].is_login
                if (balance > tarif) {
                    res.send(`${balance}`)
                    if (islogin == 0) {
                        db.query(`UPDATE userinfo set last_entry = ${now}, is_login = 1 where rfid = '${rfid}'`, (err, rows, field) => {
                            // res.send(`${balance}`)
                        })
                    }
                }
                else res.sendStatus(500)
            }
            else
                res.sendStatus(404)

        } catch (error) {
            console.log(error)
            res.sendStatus(404)
        }
    })
})

app.get('/exit', (req, res) => {
    let now = Date.now()
    let rfid = req.query.rfid
    db.query(`SELECT * from userinfo where rfid = '${rfid}'`, (err, rows, field) => {
        try {
            if (rows[0] != null) {
                let balance = rows[0].balance
                if (balance > tarif) {
                    let charge = Math.round(((now - rows[0].last_entry) / (3600 * 1000)) * tarif)
                    let newbalance = balance - charge
                    let islogin = rows[0].is_login
                    if (islogin == 1) {
                        db.query(`UPDATE userinfo set balance = ${newbalance}, is_login=0 where rfid = '${rfid}'`, (err, rows2, field) => {
                            res.send(`${newbalance} `)
                        })
                    }
                    else
                        db.query(`SELECT * from userinfo WHERE rfid = '${rfid}'`, (err, rows2, field) => {
                            res.send(`${rows2[0].balance}`)
                        })

                }
                else res.sendStatus(500)
            }
            else
                res.sendStatus(404)

        } catch (error) {
            res.sendStatus(404)
        }
    })
})

app.post('/recharge', (req, res) => {
    let rfid = req.body.rfid
    let balance = req.body.balance
    console.log(`rfid : ${rfid} saldo : ${balance}`)
    db.query(`SELECT * from userinfo where rfid = '${rfid}'`, (err, rows, field) => {
        try {
            if (rows[0] != null) {
                db.query(`UPDATE userinfo set balance=balance + ${balance} where rfid = '${rfid}'`, (err, rows, field) => {
                    res.send('OK')
                })
            }
            else
                res.sendStatus(404)

        } catch (error) {
            res.sendStatus(404)
        }
    })
})

app.post('/create', (req, res) => {
    let rfid = req.body.rfid
    let name = req.body.name
    console.log(req.body)
    db.query(`SELECT * from userinfo where rfid = '${rfid}'`, (err, rows, field) => {
        if (rows[0] != null) {
            res.sendStatus(404)
        }
        else
            db.query(`INSERT INTO userinfo (rfid, name) values ('${rfid}','${name}')`, (err, rows, field) => {
                res.send('ok')
            })
    })
})

app.listen(3000, console.log(`Web Server : ${ip.address()}:3000`))