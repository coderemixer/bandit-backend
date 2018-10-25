User.create(
  username: 'admin',
  password: CryptoService.generate('admin'),
  nickname: 'Admin',
  is_admin: true,
)
