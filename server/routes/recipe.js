var express = require('express');
var router = express.Router();
var recipe = require('../controller/recipe');
let {isLoggedIn} = require('../middleware/authenticate');

router.post('/add', recipe.add);
router.post('/update', recipe.update);
router.post('/search', recipe.search);
router.post('/delete', recipe.delete);

module.exports = router;
