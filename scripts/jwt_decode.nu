# Decode an jwt token
def "decode jwt" [
  --all (-a) # Print header, payload & signature
] {
  let parts = ($in | split row ".")

  if $all {
    {
      header:  ($parts.0 | decode base64 --character-set standard-no-padding | from json)
      payload: ($parts.1 | decode base64 --character-set standard-no-padding | from json)
      signature: $parts.2
    }
  } else {
    ($parts.1 | decode base64 --character-set standard-no-padding | from json)
  }
}

# Decode an jwt token
def "jwt decode" [
  token: string # A JWT Token
  --all (-a)    # Print header, payload & signature
] {
  if $all {
    $token | decode jwt --all
  } else {
    $token | decode jwt
  }
}

