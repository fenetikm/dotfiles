# INSTALLATION

Notes on installing:
- Install the LSPs ya self, don't use Mason e.g. `volta install pyright`
- Have to give full disk access to kitty before installation, otherwise might get directories not owned that will need destroying
- Swap file issue: need to create the dir and give the user permissions `sudo chown -R $USER swap ` inside of `.local/state/nvim/state`
