import axios from "axios";
import {
  CONST
} from './const';
const url = CONST.CONST_URL.concat('/users/');

class usersApi {
  static login(username, password) {
    console.log(url)
    return new Promise(async (resolve, reject) => {
      try {
        const res = await axios.post(`${url}login`, {
          username,
          password
        }, {
          withCredentials: true
        });
        resolve(res.data);
      } catch (err) {
        reject(err);
      }
    });
  }

  static check_logged() {
    return new Promise(async (resolve, reject) => {
      try {
        const res = await axios.post(`${url}check_logged`, {
          withCredentials: true
        });
        resolve(res.data);
      } catch (err) {
        reject(err);
      }
    });
  }

  static logout() {
    return new Promise(async (resolve, reject) => {
      try {
        const res = await axios.post(`${url}logout`, {
          withCredentials: true
        });
        resolve(res.data);
      } catch (err) {
        reject(err);
      }
    });
  }
}

export default usersApi;