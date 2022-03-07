module.exports = {
  mode: 'jit',
  purge: [
    './app/**/*.html.erb',
    './app/**/*.html.slim',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        ariel: '#aad6ec',
        aliceblue: '#f0f8ff',
        taikoh: '#f69c9f',
        nibi: '#656765',
        zincdust: '#5b5b5b',
        kamenozoki: '#a5dee4',
        wasurenagusa: '#7db9de',
        shironeri: '#fcfaf2'
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
