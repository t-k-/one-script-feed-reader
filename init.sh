#!/bin/sh
script_dir="$(cd `dirname $0` && pwd)"
bin_dir=/usr/local/bin
uniq_name=my-feed-open
open_script=${uniq_name}.sh
app_dir=/home/tk/.local/share/applications
mime_dir=/home/tk/.local/share/mime/packages
feed_ext=tkfd

# check if we have root permission
touch /root/test || exit

colorpri() {
	tput setaf 2
	echo $1
	tput sgr0
}

colorpri "symbol link global command: $open_script"
ln -sf "$script_dir/$open_script" $bin_dir/$open_script

colorpri "adding mime file: ${mime_dir}/application-x-${uniq_name}.xml"
mkdir -p ${mime_dir}
cat << EOF | tee ${mime_dir}/application-x-${uniq_name}.xml 
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
<mime-type type="application/x-${uniq_name}">
<comment></comment>
<icon name="application-x-${uniq_name}"/>
<glob-deleteall/>
<glob pattern="*.${feed_ext}"/>
</mime-type>
</mime-info>
EOF

colorpri "adding application file: ${app_dir}/${uniq_name}.desktop"
mkdir -p ${app_dir}
cat << EOF | tee ${app_dir}/${uniq_name}.desktop
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=tk feed open
Comment=
Exec=${open_script} %f
Terminal=true
StartupNotify=true
MimeType=application/x-${uniq_name};
Categories=GNOME;GTK;Utility;TextEditor;
EOF

colorpri "update default app database..."
update-desktop-database $app_dir
update-mime-database $mime_dir/..
