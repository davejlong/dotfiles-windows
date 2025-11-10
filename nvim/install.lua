-- Load config from dotfiles
dotfilespath = string.gsub(os.getenv('DotfilesPath'), "\\", "/") .. "/nvim/init.lua"
package.path = package.path .. ";" .. dotfilespath
require('nvim')