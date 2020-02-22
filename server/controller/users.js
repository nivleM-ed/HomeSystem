let bcrypt = require('bcrypt');
const passport = require('passport');
const myPassport = require('../passport_setup')(passport);
const {
    isEmpty
} = require('lodash');
var sequelize = require('sequelize');
const op = sequelize.Op;
var CONST = require('../const');

const generateHash = function (password) {
    return bcrypt.hashSync(password, bcrypt.genSaltSync(8), null)
}

//login
exports.login = function (req, res, next) {
    console.log(req.body)
    passport.authenticate('local', {
        session: true
    }, function (err, user, info) {
        if (err) {
            res.send(err);
        } else if (!user) {
            res.send(info);
        } else {
            req.logIn(user, function (err) {
                res.send(user);
            })
        }
    })(req, res, next);
}

//check if logged in
exports.check_logged = function (req, res, next) {
    try {
        if (req.user) {
            res.status(200).send({
                id: req.user.id
            });
        } else {
            res.send({
                err: "noCookie"
            });
        }
    } catch (err) {
        res.send({
            err: "systemErr"
        })
    }
}

//logout
exports.logout = function (req, res, next) {
    try {
        console.log('destroy')
        req.logout();
        req.session.destroy();
        
        res.status(200).send({
            logout: "logout"
        });
    } catch (err) {
        console.log(err)
        res.status(500).send(err)
    }

}

exports.version = function (req, res, next) {
    try {
        let version = CONST.version
        res.send(version)
    } catch (err) {
        res.status(500).send(err)
    }
}
