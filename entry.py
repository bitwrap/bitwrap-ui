#!/usr/bin/env python
from livereload import Server
import bitwrap_ui
server = Server()
server.watch('./bitwrap_ui/_brython/')
server.serve(port=8080, root='./bitwrap_ui/_brython')
