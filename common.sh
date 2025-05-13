cleanup_knownhosts () {
  case "$OSTYPE" in
    darwin*|bsd*)
      sed_no_backup=( -i "''" )
      ;; 
    *)
      sed_no_backup=( -i )
      ;;
  esac

  sed ${sed_no_backup[@]} "s/$1.*//" ~/.ssh/known_hosts
  sed ${sed_no_backup[@]} "/^$/d" ~/.ssh/known_hosts
  sed ${sed_no_backup[@]} "/# ^$/d" ~/.ssh/known_hosts
}

wait_for_ssh () {
  echo "Waiting for SSH to become available..."
  if [ -z $2 ]; then
    while ! nc -z $1 22; do
        echo "Failed to connect to $1. Retrying in 5 seconds..."
        sleep 5
    done
  else
    set +e
    while true; do
      ssh -o 'UserKnownHostsFile=/dev/null' -o 'StrictHostKeyChecking=no' -o 'ConnectTimeout=5' "$2@$1" uname -a
      if [ $? -eq 0 ]; then
        break
      else
        echo "Failed to connect to $1. Retrying in 5 seconds..."
        sleep 5
      fi
    done
    set -e
  fi
}

# # The following code is for local SSH keys
# # and is commented out. Uncomment if needed.

prepare_keystore () {
  # nothing to do
}

get_private_key () {
  cat ~/.ssh/$1
}

get_public_key () {
  cat ~/.ssh/$1.pub
}


# # The following code is for Bitwarden
# # and is used to manage SSH keys.

# prepare_keystore() {
#   # Check if session is valid
#   bw status | jq -e '.status == "unlocked"' &>/dev/null
#   if [ $? -ne 0 ]; then
#     echo "Unlocking Bitwarden vault..."
#     export BW_SESSION=$(bw unlock --raw)
#     if [ $? -ne 0 ]; then
#       echo "Failed to unlock Bitwarden vault."
#       return 1
#     fi
#     echo "Bitwarden vault unlocked successfully."
#   else
#     echo "Bitwarden vault is already unlocked."
#   fi
#   # Ensure we have the latest data
#   bw sync &>/dev/null
#   return 0
# }

# get_private_key() {
#   local key_name="${1:-id_ed25519}"
#   local folder_name="SSH Keys"
  
#   # First make sure the vault is unlocked
#   bw status | jq -e '.status == "unlocked"' &>/dev/null
#   if [ $? -ne 0 ]; then
#     prepare_keystore
#   fi
  
#   # Get the folder ID for "SSH Keys"
#   FOLDER_ID=$(bw list folders | jq -r --arg name "$folder_name" '.[] | select(.name==$name) | .id')
  
#   if [ -z "$FOLDER_ID" ]; then
#     echo "Error: Folder '$folder_name' not found in Bitwarden vault." >&2
#     return 1
#   fi
  
#   # Get the item ID for the specified key in the SSH Keys folder
#   ITEM_ID=$(bw list items --folderid $FOLDER_ID | jq -r --arg name "$key_name" '.[] | select(.name==$name) | .id')
  
#   if [ -z "$ITEM_ID" ]; then
#     echo "Error: Key '$key_name' not found in '$folder_name' folder." >&2
#     return 1
#   fi
  
#   # Get the private key field from the item
#   bw get item $ITEM_ID | jq -r '.fields[] | select(.name=="private key") | .value'
# }

# get_public_key() {
#   local key_name="${1:-id_ed25519}"
#   local folder_name="SSH Keys"
  
#   # First make sure the vault is unlocked
#   bw status | jq -e '.status == "unlocked"' &>/dev/null
#   if [ $? -ne 0 ]; then
#     prepare_keystore
#   fi
  
#   # Get the folder ID for "SSH Keys"
#   FOLDER_ID=$(bw list folders | jq -r --arg name "$folder_name" '.[] | select(.name==$name) | .id')
  
#   if [ -z "$FOLDER_ID" ]; then
#     echo "Error: Folder '$folder_name' not found in Bitwarden vault." >&2
#     return 1
#   fi
  
#   # Get the item ID for the specified key in the SSH Keys folder
#   ITEM_ID=$(bw list items --folderid $FOLDER_ID | jq -r --arg name "$key_name" '.[] | select(.name==$name) | .id')
  
#   if [ -z "$ITEM_ID" ]; then
#     echo "Error: Key '$key_name' not found in '$folder_name' folder." >&2
#     return 1
#   fi
  
#   # Get the public key field from the item
#   bw get item $ITEM_ID | jq -r '.fields[] | select(.name=="public key") | .value'
# }


# # The following code is for 1Password, but it's commented out
# # and not used in this script. Uncomment if needed.

# prepare_keystore () {
#   op account get --account my &>/dev/null
#   if [ $? -ne 0 ]; then
#       eval $(op signin --account my)
#   fi
# }
# # 
# get_private_key () {
#   echo "$(op read "op://Private/$1/private key?ssh-format=openssh")"
# }
# # 
# get_public_key () {
#   echo "$(op read "op://Private/$1/public key")"
# }
