export default class recipeClass {
  constructor() {
    var username = null;
    var password = null;
  }
  get username() {
    return this._username;
  }
  set username(in_username) {
    this._username = in_username;
  }

  get password() {
    return this._password;
  }
  set password(in_password) {
    this._password = in_password;
  }

  //methods
  toJson() {
    let temp = JSON.stringify(this);
    return JSON.parse(temp);
  }
}
