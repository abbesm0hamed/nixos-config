# Generate SSH key

ssh-keygen -t ed25519 -C "email" -f ~/.ssh/github_rsa
cat ~/.ssh/github_rsa.pub

# Test SSH connection

ssh -T git@github.com
