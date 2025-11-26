/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./login/**/*.ftl"],
  theme: {
    extend: {},
  },
  plugins: [require("daisyui")],
  daisyui: {
    themes: ["light"],
  },
}
