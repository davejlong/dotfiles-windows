<#
 .Synopsis
  Generates a password similar to Office 365 password generator.

 .Description
  Generates a password similar to Office 365 password generator. Useful for
  setting temporary passwords.

 .Example
    # Get a random password
    Get-RandomPassword
#>
function Get-RandomPassword {
  $Consonents = 'B','C','D','F','G','H','J','K','L','M','N','P','Q','R','S','T','V','W','X','Z'
  $Vowels = 'A','E','I','O','U','Y'

  function Get-RandomConsonant() { Get-Random -InputObject $Consonents }
  function Get-RandomVowel() { Get-Random -InputObject $Vowels }

  $Password = "$(Get-RandomConsonant)"
  $Password += "$(Get-RandomVowel)$(Get-RandomConsonant)$(Get-RandomVowel)".ToLower()
  $Password += "$(Get-Random -Minimum 1000 -Maximum 9999)"
  return $Password
}