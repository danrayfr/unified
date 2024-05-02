const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        work: ['Work Sans'],
        serif: ["Playfair Display"],
        poppins: ['Poppins']
      },
      colors: {
        graphite: '#23282E',
        ivory: '#F3DAC9',
        stone: '#B3B7B0',
        coral: '#F05754',
        fern: '#003822',
        gold: '#EAB857',
        lightGraphite: '#525559',
        darkStone: '#919489',
        paleFern: '#518F6F',
        paleCoral: '#F9B4A4',
        paleGold: '#FA31A3',
        offWhite: '#FFF8F5',
        'lila': {
          50: '#fbfaff',
          100: '#f7f5ff',
          200: '#eae6fe',
          300: '#e2dcfe',
          400: '#d7cefd',
          500: '#c8befd',
          600: '#b5a6fc',
          700: '#a08dfb',
          800: '#836bfa',
          900: '#5534f9'
        },
        beige: '#f6efe5',
        violet: '#8671c4'
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
