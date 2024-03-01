/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020-2024 Ryo Nakano <ryonakaknock3@gmail.com>
 */

public class MainWindow : Adw.ApplicationWindow {
    private Adw.ToastOverlay overlay;

    public MainWindow (Application app) {
        Object (
            application: app,
            title: "KonbuCase"
        );
    }

    construct {
        var source_combo_entry = new Widgets.ComboEntry (
            "source",
            _("Convert from:"),
            true
        );

        var separator = new Gtk.Separator (Gtk.Orientation.VERTICAL) {
            vexpand = true
        };

        var result_combo_entry = new Widgets.ComboEntry (
            "result",
            _("Convert to:"),
            // Make the text view uneditable, otherwise the app freezes
            false
        );

        var main_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        main_box.append (source_combo_entry);
        main_box.append (separator);
        main_box.append (result_combo_entry);

        overlay = new Adw.ToastOverlay () {
            child = main_box
        };

        var style_submenu = new Menu ();
        style_submenu.append (_("Light"), "app.color-scheme(%d)".printf (Adw.ColorScheme.FORCE_LIGHT));
        style_submenu.append (_("Dark"), "app.color-scheme(%d)".printf (Adw.ColorScheme.FORCE_DARK));
        style_submenu.append (_("System"), "app.color-scheme(%d)".printf (Adw.ColorScheme.DEFAULT));

        var menu = new Menu ();
        menu.append_submenu (_("Style"), style_submenu);

        var menu_button = new Gtk.MenuButton () {
            tooltip_text = _("Main Menu"),
            icon_name = "open-menu",
            menu_model = menu,
            primary = true
        };

        var header = new Adw.HeaderBar ();
        header.pack_end (menu_button);

        var toolbar_view = new Adw.ToolbarView ();
        toolbar_view.add_top_bar (header);
        toolbar_view.set_content (overlay);

        content = toolbar_view;
        width_request = 700;
        height_request = 500;

        source_combo_entry.source_view.grab_focus ();

        source_combo_entry.text_copied.connect (show_toast);
        result_combo_entry.text_copied.connect (show_toast);
    }

    private void show_toast () {
        var toast = new Adw.Toast (_("Text copied!"));
        overlay.add_toast (toast);
    }
}
