class AccountLogo {
  final int id;
  final String title;
  final String accountImage;
  AccountLogo({
    required this.id,
    required this.title,
    required this.accountImage,
  });
}

final List<AccountLogo> accountsList = [
  AccountLogo(
    id: 1,
    title: 'Google',
    accountImage: 'assets/icons/google.svg',
  )
];
