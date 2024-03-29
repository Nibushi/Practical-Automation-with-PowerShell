# Copying File to Remote Computers

## Copy-Item

- Copies Item(s) from one location to another
  - Doesn't cut or delete original item
- Able to copy and rename items in the same command
- Use locally or on remote machine
- Use -ToSession to work with remote computers
- Useful if you don't have UNC or Shared Network access to the machine
- Use Cases could be
  - Environments where no copying to specific servers
  - Specific port restrictions
  - Need to copy custom scripts to remote computers or copy admin programs to remote computers

```powershell

# Set Location and Destination
$location = "\\10.0.0.5\files\"
$destination = "C:\Files"

# Copy File to local computer
Copy-Item -Path "$($location)\*" -Destination $destination -Recurse

# Copy Files to Remote Computer
$Sess = New-PSSession -ComputerName "10.0.0.5"
Copy-Item -Path "$($location)\*" -Destination $destination -Recurse -ToSession $Sess

```
