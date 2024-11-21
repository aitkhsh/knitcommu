// tailwind.config.js
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [require("daisyui")],
  daisyui: {
    themes: ["pastel"],
    darkTheme: false,
  },
  // theme: {
  //   extend: {
  //     animation: {
  //       "flip-horizontal": "flip-horizontal 0.7s ease-in-out both",
  //     },
  //     keyframes: {
  //       "flip-horizontal": {
  //         "0%": {
  //           transform: "rotateY(0)",
  //         },
  //         "100%": {
  //           transform: "rotateY(180deg)",
  //         },
  //       },
  //     },
  //   },
  // },
};
