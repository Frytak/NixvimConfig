{ ... }: {
    userCommands = {
    };

    colorschemes.gruvbox = {
        enable = true;
    };

    # Set the <LEADER> to space-bar
    globals = {
        mapleader = " ";
        maplocalleader = "\\";
    };

    opts = {
        # Use spaces instead of TABs
        expandtab = true;
        tabstop = 4;
        shiftwidth = 4;
        softtabstop = 0;

        autoindent = true;
        smartindent = true;

        # Relative numbers on the left
        number = true;
        relativenumber = true;

        # Word wrap
        breakindent = true;
        formatoptions = "l";
        lbr = true;

        # Make the diagnostic gutter visible at all time
        signcolumn = "yes";
    };
}
