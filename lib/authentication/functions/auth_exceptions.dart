String authExceptionToString(String error) {
  if (error.contains('email-already-in-use')) {
    return 'This email is already in use.';
  } else if (error.contains('invalid-email')) {
    return 'This email is invalid.';
  } else if (error.contains('operation-not-allowed')) {
    return 'Sorry this operation is not allowed.';
  } else if (error.contains('weak-password')) {
    return 'Please enter a password with more than 6 characters.';
  } else if (error.contains('user-disabled')) {
    return 'This user is currently disabled';
  } else if (error.contains('user-not-found')) {
    return 'There was no user with this information found.';
  } else if (error.contains('wrong-password')) {
    return 'Incorrect password';
  }

  return 'Error occured. Please try again later';
}
