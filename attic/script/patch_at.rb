# encoding: utf-8
#
#  note:
#   run from repo root
#   $ ruby ./script/patch.rb

require 'pp'
require 'sportdb/models'

p = SportDb::Patcher.new( '.', path: '/\d{4}-\d{2}/$' )
change_logs = p.patch( true )   # note: defaults to save=false

pp change_logs
