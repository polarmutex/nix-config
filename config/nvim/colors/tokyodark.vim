lua << EOF
for k in pairs(package.loaded) do
    if k:match("polarmutex.colorschemes.tokyodark.*") then package.loaded[k] = nil end
end
EOF

lua require('polarmutex.colorschemes.tokyodark').setup()
