import CookiesEuBanner from 'cookies-eu-banner'
//import 'cookies-eu-banner/css/cookies-eu-banner.default.css'

document.addEventListener("turbolinks:load", () => {
  new CookiesEuBanner(() => {},true)
})