# frozen_string_literal: true

board = Board.find_or_create_by!(name: 'My Project')

todo = board.columns.find_or_create_by!(name: 'To Do') { |c| c.position = 0 }
in_progress = board.columns.find_or_create_by!(name: 'In Progress') { |c| c.position = 1 }
done = board.columns.find_or_create_by!(name: 'Done') { |c| c.position = 2 }

todo.tasks.find_or_create_by!(title: 'Set up project structure') do |t|
  t.description = 'Initialize Rails app with Hotwire'
  t.position = 0
end
todo.tasks.find_or_create_by!(title: 'Design database schema') do |t|
  t.description = 'Create Board, Column, and Task models'
  t.position = 1
end
todo.tasks.find_or_create_by!(title: 'Add Tailwind styling') do |t|
  t.description = 'Make the board look nice'
  t.position = 2
end

in_progress.tasks.find_or_create_by!(title: 'Implement Turbo Frames') do |t|
  t.description = 'Inline editing and lazy loading'
  t.position = 0
end
in_progress.tasks.find_or_create_by!(title: 'Add Turbo Streams') do |t|
  t.description = 'Real-time updates without page reload'
  t.position = 1
end

done.tasks.find_or_create_by!(title: 'Learn Hotwire basics') do |t|
  t.description = 'Read the docs and tutorials'
  t.position = 0
end
