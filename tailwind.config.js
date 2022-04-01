module.exports = {
  mode: 'jit',
  purge: {
    content: [
      './app/**/*.html.erb',
      './app/**/*.html.slim',
      './app/helpers/**/*.rb',
      './app/javascript/**/*.js',
    ],
    safelist: [],
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        ariel: '#aad6ec',
        aliceblue: '#f0f8ff',
        taikoh: '#f69c9f',
        nibi: '#656765',
        shironeri: '#fcfaf2',
        shiro: '#f4f5f7',
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
