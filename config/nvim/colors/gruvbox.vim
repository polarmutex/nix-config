" include our theme file and pass it to lush to apply
lua << EOF
for k in pairs(package.loaded) do
    if k:match("polarmutex.gruvbox.*") then package.loaded[k] = nil end
end
EOF

lua require('polarmutex.colorschemes.gruvbox').setup()
