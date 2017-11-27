#-- encoding: UTF-8
#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2015 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

class WorkPackageCustomFieldDataMigration < ActiveRecord::Migration
  def self.up
    set_custom_fields_type('IssueCustomField', 'WorkPackageCustomField')
    set_custom_values_type('Issue', 'WorkPackage')
  end

  def self.down
    set_custom_fields_type('WorkPackageCustomField', 'IssueCustomField')
    set_custom_values_type('WorkPackage', 'Issue')
  end

  private

  def set_custom_fields_type(from_type, to_type)
    ActiveRecord::Base.connection.execute <<-SQL
      UPDATE #{custom_fields_table}
      SET type = #{quote_value(to_type)}
      WHERE type = #{quote_value(from_type)}
    SQL
  end

  def set_custom_values_type(from_type, to_type)
    ActiveRecord::Base.connection.execute <<-SQL
      UPDATE #{custom_values_table}
      SET customized_type = #{quote_value(to_type)}
      WHERE customized_type = #{quote_value(from_type)}
    SQL
  end

  def custom_fields_table
    ActiveRecord::Base.connection.quote_table_name('custom_fields')
  end

  def custom_values_table
    ActiveRecord::Base.connection.quote_table_name('custom_values')
  end

  def quote_value(s)
    ActiveRecord::Base.connection.quote(s)
  end
end
