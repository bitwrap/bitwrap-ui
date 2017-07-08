#!/usr/bin/env node

var budo = require('budo');
var coffeeify = require('coffeeify');

budo('./app/index.coffee', {
  serve: 'bundle.js',
  live: true,
  host: '127.0.0.1',
  port: 8880,
  wg: '**/*.{html,css,js,json}',
  stream: process.stdout,
  browserify: {
    transform: [ coffeeify ]
  }
})
