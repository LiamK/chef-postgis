execute 'create_postgis_template' do
  # Use egrep if you want to include the '|'.
  # Should be only_if, since if grep is successful it returns 0.
  only_if "psql -qAt --list | egrep -q '^#{node['postgis']['template_name']}\|'", :user => 'postgres'
  user 'postgres'
  command <<CMD
(createdb -E UTF8 --locale=#{node['postgis']['locale']} #{node['postgis']['template_name']} -T template0) &&
(psql -d #{node['postgis']['template_name']} -f `pg_config --sharedir`/contrib/postgis-2.0/postgis.sql) &&
(psql -d #{node['postgis']['template_name']} -f `pg_config --sharedir`/contrib/postgis-2.0/spatial_ref_sys.sql)
CMD
  action :run
end
