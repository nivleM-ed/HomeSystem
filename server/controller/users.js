let bcrypt = require('bcrypt');
const passport = require('passport');
const myPassport = require('../passport_setup')(passport);
const {
    isEmpty
} = require('lodash');
var sequelize = require('sequelize');
const op = sequelize.Op;

const generateHash = function (password) {
    return bcrypt.hashSync(password, bcrypt.genSaltSync(8), null)
}

//login
exports.login = function (req, res, next) {
    console.log('1')
    console.log(req.body)
    passport.authenticate('local', {
        session: true
    }, function (err, user, info) {
        if (err) {
            console.log('2:',err)
            res.send(err);
        } else if (!user) {
            console.log('3:', info)
            res.send(info);
        } else {
            console.log('4')
            req.logIn(user, function (err) {
                res.send(user);
            })
        }
    })(req, res, next);
}

//check if logged in
exports.check_logged = function (req, res, next) {
    try {
        if (req.user)
            res.status(200).send({
                id: req.user.id
            });
        else {
            res.send({
                err: "noCookie"
            });
        }
    } catch (error) {
        res.send({
            error: "systemErr"
        })
    }
}

//logout
exports.logout = function (req, res, next) {
    req.logout();
    req.session.destroy();
    res.status(200).send({
        logout: "logout"
    });
}