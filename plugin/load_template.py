import vim
import os
import getpass
from string import Template
from datetime import datetime

fulldate = datetime.now()
year = fulldate.year
author = vim.eval("g:erl_author") or getpass.getuser()
company = vim.eval("g:erl_company")

name = vim.current.buffer.name or "untitled"
basename = os.path.split(os.path.splitext(name)[0])[1]

tpl_dir = vim.eval("g:erl_tpl_dir")
tpl_file = vim.eval("a:tpl_file")
tpl = os.path.join(tpl_dir, tpl_file)
template = open(tpl, "r").read()
s = Template(template)
output = s.substitute(author=author, fulldate=fulldate,
    basename=basename, year=year, company=company)

if vim.eval("g:erl_replace_buffer")==1:
    del vim.current.buffer[:]

vim.current.buffer.append(output.split("\n"), 0)
vim.command("set filetype=erlang")

