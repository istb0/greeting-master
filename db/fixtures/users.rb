if User.exists?(1)
  User.update(id: 1, name: 'guest', email: 'guest@example.com',
    password: 'guest', password_confirmation: 'guest')
else
  User.create!(id: 1, name: 'guest', email: 'guest@example.com',
    password: 'guest', password_confirmation: 'guest')
end
