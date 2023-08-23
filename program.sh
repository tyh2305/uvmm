#!/bin/bash

# Title: University Venue Management System
# Author1: Tan Yi Hong
# Author2: Ong Tun Jiun
# Date: 30/07/2023
# Course: BACS2093 Operating Systems
# Purpose: University Venue Management System

# Common Variables
break_line="----------------------------------------"
empty_line="\n"

# Task 1 - Menu Script
# ====================
# Author: Tan Yi Hong
# Description: Print Main Menu

main_menu() {
  clear

  main_menu_text="University Venue Management Menu \n"
  main_menu_option="A - Register New Patron \nB - Search Patron Details \nC - Add New Venue \nD - List Venue \nE - Book Venue \n\nQ - Exit from program \n"
  main_menu_choice="Please select a choice:"
  option=""
  echo -e "$main_menu_text"
  echo -e "$main_menu_option"

  ## Read Option
  read -rp "$main_menu_choice" option

  ## Clear Screen
  clear
}

# Task 2 - Patron Registration

## Validation functions

## Check Patron ID
## ====================
## Author: Tan Yi Hong
## Description: Check if patron id is valid
## Input: Patron ID
## Output:
##   0 - Patron ID is valid
##   1 - Patron ID is invalid

check_patron_id() {

  patron_id=$1
  if [ -z "$patron_id" ]; then
    echo 1
    return
  fi

  # Read patron.txt file
  patron_file=$(cat patron.txt)
  # Split patron.txt file by new line
  # Loop through patron.txt file
  for line in $patron_file; do
    # Split patron.txt file by :
    IFS=':' read -ra patron_dat <<<"$line"
    # Check if patron id is equal to patron id in patron.txt file
    if [ "$patron_id" = "${patron_dat[0]}" ]; then
      echo 1
      return
    fi
  done

  # Patron ID is not found
  # Validate patron id format in 00AAA00000
  if [[ "$patron_id" =~ ^[0-9]{2}[A-Z]{3}[0-9]{5}$ ]]; then
    echo 0
    return
  fi

  # Default invalid patron id
  echo 1
  return
}

## Check Patron Name
## ====================
## Author: Tan Yi Hong
## Description: Check if patron name is valid
## Input: Patron Name
## Output:
##   0 - Patron Name is valid
##   1 - Patron Name is invalid

check_patron_name() {
  patron_name=$1

  # Check name only contains alphabets and spaces
  if [[ "$patron_name" =~ ^[a-zA-Z[:space:]]+$ ]]; then
    echo 0
    return
  else
    echo 1
    return
  fi

}

## Check Patron Contact
## ====================
## Author: Tan Yi Hong
## Description: Check if patron contact is valid
## Input: Patron Contact
## Output:
##   0 - Patron Contact is valid
##   1 - Patron Contact is invalid

check_patron_contact() {
  patron_contact=$1

  # Check contact only contains number and + - symbol
  if [[ "$patron_contact" =~ ^[0-9+-]+$ ]]; then
    echo 0
    return
  else
    echo 1
    return
  fi

}

## Check Patron Email
## ====================
## Author: Tan Yi Hong
## Description: Check if patron email is valid
## Input: Patron Email
## Output:
##   0 - Patron Email is valid
##   1 - Patron Email is invalid

check_patron_email() {
  patron_email=$1

  # Check email address is valid
  if [[ "$patron_email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo 0
    return
  else
    echo 1
    return
  fi
}

## Utility functions

## Write Patron
## ====================
## Author: Tan Yi Hong
## Description: Write patron details to patron.txt file
## Input: Patron ID, Patron Full Name, Patron Contact Number, Patron Email Address
## Output: None

write_patron() {
  patron_id=$1
  patron_full_name=$2
  patron_contact_number=$3
  patron_email_address=$4

  echo -e "$patron_id:$patron_full_name:$patron_contact_number:$patron_email_address" >>patron.txt
}

# Task 2
## Register Patron
register_patron() {
  patron_menu="Patron Registration"
  flag=true

  while true; do
    echo -e "$patron_menu"
    echo -e "$break_line"

    read -rp "Patron ID (As per TARUMT format):" patron_id
    # Patron ID Validation
    flag=$(check_patron_id "$patron_id")
    if [ "$flag" == "1" ]; then
      clear
      echo -e "Patron ID invalid \nPlease try again\n\n"
      continue
    fi

    read -rp "Patron Full Name (As per NRIC):" patron_full_name
    # Patron Full Name Validation
    flag=$(check_patron_name "$patron_full_name")
    if [ "$flag" == "1" ]; then
      clear
      echo -e "Patron Name should only contains alphabets\nPlease try again\n\n"
      continue
    fi

    read -rp "Contact Number:" patron_contact_number
    # Patron Contact Number Validation
    flag=$(check_patron_contact "$patron_contact_number")
    if [ "$flag" == "1" ]; then
      clear
      echo -e "Patron Contact Number should only contains number and + - symbol\nPlease try again\n\n"
      continue
    fi

    read -rp "Email Address:" patron_email_address
    # Patron Email Address Validation
    flag=$(check_patron_email "$patron_email_address")
    if [ "$flag" == "1" ]; then
      clear
      echo -e "Patron Email Address invalid\nPlease try again\n\n"
      continue
    fi
    echo -e "$empty_line"

    write_patron "$patron_id" "$patron_full_name" "$patron_contact_number" "$patron_email_address"

    read -rp "Register Another Patron? (y) es or (q)uit:" register_another_patron
    if [ "$register_another_patron" = "q" ]; then
      clear
      break
    fi
    clear
  done
}

## Search Patron Details
## ====================
## Author: Tan Yi Hong
## Description: Search patron details by patron id
## Input: Patron ID
## Output: Patron Full Name, Patron Contact Number, Patron Email Address

search_patron_details() {
  while true; do
    echo -e "Search Patron Details"
    read -rp "Enter Patron ID:" patron_id
    echo -e "$break_line"

    # Read patron.txt file
    patron_file=$(cat patron.txt)
    found=false

    # Loop through patron.txt file
    while IFS= read -r line; do
      # Split patron.txt file by :
      IFS=':' read -ra patron_dat <<<"$line"
      # Check if patron id is equal to patron id in patron.txt file
      if [ "$patron_id" = "${patron_dat[0]}" ]; then
        echo -e "Patron Full Name: ${patron_dat[1]}"
        echo -e "Contact Number: ${patron_dat[2]}"
        echo -e "Email Address: ${patron_dat[3]}"
        echo -e "$break_line"
        found=true
        break
      fi

    done <<<"$patron_file"

    if [ "$found" = false ]; then
      echo -e "Patron ID not found"
    fi

    read -rp "Search Another Patron? (y) es or (q)uit:" search_another_patron
    if [ "$search_another_patron" = "q" ]; then
      clear
      break
    fi
    clear
  done
}


# Task 3

# Check Block Name
# ================
# Author: Ong Tun Jiun
# Description: Check block name only contains alphabets
# Input: block_name
# Output: 0 if block name only contains alphabets, 1 if block name contains other than alphabets
check_block_name() {
  block_name=$1

  # Check name only contains alphabets
  if [[ "$block_name" =~ ^[a-zA-Z]+$ ]]; then
    echo 0
    return
  else
    echo 1
    return
  fi
}

# Check Room Number
# =================
# Author: Ong Tun Jiun
# Task: 3 - Add New Venue
# Description: Check room number only contains alphabets and numbers
# Input: room_number
# Output: 0 if room number only contains alphabets and numbers, 1 if room number contains other than alphabets and numbers
check_room_number() {
  room_number=$1

  flag=0

  # Check room number only contains alphabets and numbers
  if [[ "$room_number" =~ ^[a-zA-Z0-9]+$ ]]; then
    flag=0
  else
    flag=1
  fi

  # Read venue.txt file
  venue_file=$(cat venue.txt)

  # Loop through venue.txt file
  for line in $venue_file; do
    # Split venue.txt file by :
    IFS=':' read -ra venue_dat <<<"$line"
    # Check if room number is equal to room number in venue.txt file
    if [ "$room_number" = "${venue_dat[1]}" ]; then
      flag=2
    fi
  done

  echo $flag
  return
}

# Check Room Type
# ===============
# Author: Ong Tun Jiun
# Task: 3 - Add New Venue
# Description: Check room type only contains alphabets
# Input: room_type
# Output: 0 if room type only contains alphabets, 1 if room type contains other than alphabets
check_room_type() {
  room_type=$1

  # Check room type only contains alphabets
  if [[ "$room_type" =~ ^[a-zA-Z[:space:]]+$ ]]; then
    echo 0
    return
  else
    echo 1
    return
  fi
}

# Check Capacity
# ==============
# Author: Ong Tun Jiun
# Task: 3 - Add New Venue
# Description: Check capacity only contains numbers
# Input: capacity
# Output: 0 if capacity only contains numbers, 1 if capacity contains other than numbers
check_capacity() {
  capacity=$1

  # Check capacity only contains numbers
  if [[ "$capacity" =~ ^[0-9]+$ ]]; then
    echo 0
    return
  else
    echo 1
    return
  fi
}

# Check Status
# ============
# Author: Ong Tun Jiun
# Task: 3 - Add New Venue
# Description: Check status only contains alphabets
# Input: status
# Output: 0 if status only contains alphabets, 1 if status contains other than alphabets
check_status() {
  status=$1

  # Check status only contains alphabets
  if [[ "$status" =~ ^[a-zA-Z]+$ ]]; then
    echo 0
    return
  else
    echo 1
    return
  fi
}

# Add New Venue
# =============
# Author: Ong Tun Jiun
# Task: 3 - Add New Venue
# Description: Get user input, validate input and save to venue.txt file
# Input: -
# Output: -
add_new_venue() {
  flag=true

  while true; do
    echo -e "Add New Venue\n"
    echo -e "$break_line"

    read -rp "Block Name (Only alphabets): " block_name
    flag=$(check_block_name "$block_name")

    if [ "$flag" == "1" ]; then
      clear
      echo -e "Block Name should only contains alphabets\nPlease try again\n\n"
      continue
    else
      block_name=${block_name^^}
    fi

    read -rp "Room Number (Only alphabets and/or numbers): " room_number
    flag=$(check_room_number "$room_number")

    if [ "$flag" == "1" ]; then
      clear
      echo -e "Room number should only contains alphabets and numbers\nPlease try again\n\n"
      continue
    elif [ "$flag" == "2" ]; then
      clear
      echo -e "Room number already exist\nPlease try again\n\n"
      continue
    else
      room_number=${room_number^^}
    fi

    read -rp "Room Type: " room_type
    flag=$(check_room_type "$room_type")

    if [ "$flag" == "1" ]; then
      clear
      echo -e "Room type should only contains alphabets\nPlease try again\n\n"
      continue
    fi

    read -rp "Capacity: " capacity
    flag=$(check_capacity "$capacity")

    if [ "$flag" == "1" ]; then
      clear
      echo -e "Capacity should only contains numbers\nPlease try again\n\n"
      continue
    fi

    read -rp "Remarks: " remarks

    read -erp "Status (by default): " -i "Available" status
    flag=$(check_status "$status")

    if [ "$flag" == "1" ]; then
      clear
      echo -e "Status should only contains alphabets\nPlease try again\n\n"
      continue
    fi

    echo -e "$block_name:$room_number:$room_type:$capacity:$remarks:$status" >> venue.txt

    echo -e "$empty_line"
    read -rp "Add Another Venue? Type any to continue, Type Q to quit: " add_another_venue
    if [ "$add_another_venue" = "q" ] || [ "$add_another_venue" = "Q" ] ; then
      clear
      break
    fi
    clear
  done
}

# List Venue Details
# =============
# Author: Ong Tun Jiun
# Task: 3 - List Venue Details
# Description: Get user input, validate input and list venue details
# Input: -
# Output: -

list_venue_details() {
  while true; do
    echo -e "List Venue Details"

    # Input block name and do validation
    read -rp "Enter Block name (Only alphabets):" block_name
    flag=$(check_block_name "$block_name")

    if [ "$flag" == "1" ]; then
      clear
      echo -e "Block Name should only contains alphabets\nPlease try again\n\n"
      continue
    else
      block_name=${block_name^^}
    fi

    echo -e "$break_line"

    touch temp.txt

    # Print Table Header
    # echo -e "Room Number \tRoom Type \tCapacity \tRemarks \t\tStatus"
    echo -e "Room Number:Room Type:Capacity:Remarks:Status" >> temp.txt

    # Read venue.txt file
    venue_file=$(cat venue.txt)

    # Loop through venue.txt file
    while IFS= read -r line; do
      # Split venue.txt file by :
      IFS=':' read -ra venue_dat <<<"$line"
      # Check if block name is equal to block name in venue.txt file
      if [ "$block_name" = "${venue_dat[0]}" ]; then
        # Save data to temp.txt file
        echo -e "${venue_dat[1]}:${venue_dat[2]}:${venue_dat[3]}:${venue_dat[4]}:${venue_dat[5]}" >> temp.txt
      fi
    done <<< "$venue_file"

    # Count number of lines in temp.txt file
    noOfLines=$(wc -l < temp.txt)

    # Check if number of lines is 1, then print no venue found
    if [ "$noOfLines" -eq 1 ]; then
      echo -e "No venue found"
    else
      # Print table with column separator :
      column -t -s ':' temp.txt
    fi

    rm temp.txt

    echo -e "$empty_line"
    read -rp "Search Another Block Venue? Type any to continue, Type Q to quit: " search_another_venue
    if [ "$search_another_venue" = "q" ] || [ "$search_another_venue" = "Q" ]; then
      clear
      break
    fi
    clear
  done
}

# Check Booking Date
check_booking_date() {
  booking_date=$1
  flag=0

  # Check if booking date follows the format of mm/dd/yyyy
  if [[ ! "$booking_date" =~ ^[0-9]{2}/[0-9]{2}/[0-9]{4}$ ]]; then
    flag=1
  # Check if booking date is valid
  elif ! date -d "$booking_date" >/dev/null 2>&1; then
    flag=2
  # Check if booking date is tomorrow's date
  elif [[ "$booking_date" != "$(date --date=tomorrow +%m/%d/%Y)" ]]; then
    flag=3
  fi

  echo $flag
}

# Check Time From
check_time_from() {
  room_number=$1
  booking_date=$2
  time_from=$3
  
  # Check if time from follows the format of hh:mm
  if [[ ! "$time_from" =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
    echo 1
    return
  # Check if time is valid
  elif ! date -d "$time_from" >/dev/null 2>&1; then
    echo 2
    return
  # Check if time from is between 08:00 to 19.30
  elif [[ "$time_from" < "08:00" ]] || [[ "$time_from" > "19:30" ]]; then
    echo 3
    return
  fi 

  # Check through booking.txt file to detect clashes
  booking_file=$(cat booking.txt)

  # Loop through booking.txt file
  while IFS= read -r line; do
    # Split booking.txt file by :
    IFS=':' read -ra booking_dat <<<"$line"
    # Check if block name is equal to block name in venue.txt file  
    if [ "$room_number" = "${booking_dat[1]}" ]; then
      if [[ "$booking_date" != "${booking_dat[2]}" ]]; then
        continue
      fi

      if [[ ! "$time_from" < "${booking_dat[3]}:${booking_dat[4]}" ]] && [[ "$time_from" < "${booking_dat[5]}:${booking_dat[6]}" ]]; then
        echo 4
        return
      fi
    fi
  done <<< "$booking_file"
  
  echo 0
}

# Check Time To
check_time_to() {
  room_number=$1
  booking_date=$2
  time_from=$3
  time_to=$4

  # Check if time to follows the format of hh:mm
  if [[ ! "$time_to" =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
    echo 1
    return
  # Check if time is valid
  elif ! date -d "$time_to" >/dev/null 2>&1; then
    echo 2
    return
  # Check if time to is between 08:30 to 20:00
  elif [[ "$time_to" < "08:30" ]] || [[ "$time_to" > "20:00" ]]; then
    echo 3
    return 
  # Check if time to is greater than time from
  elif [[ ! "$time_to" > "$time_from" ]]; then
    echo 4
    return
  fi

  # Convert time from and time to to seconds
  time_from_seconds=$(date -d "$time_from" +%s)
  time_to_seconds=$(date -d "$time_to" +%s)

  # Calculate duration
  duration=$((time_to_seconds - time_from_seconds))

  # Check if duration is at least 30 minutes
  if [[ "$duration" -lt "1800" ]]; then
    echo 5
    return
  fi

  # Check through booking.txt file to detect clashes
  booking_file=$(cat booking.txt)

  # Loop through booking.txt file
  while IFS= read -r line; do
    # Split booking.txt file by :
    IFS=':' read -ra booking_dat <<<"$line"
    # Check if block name is equal to block name in venue.txt file
    if [ "$room_number" = "${booking_dat[1]}" ]; then
      if [[ "$booking_date" != "${booking_dat[2]}" ]]; then
        continue
      fi

      if [[ "$time_to" > "${booking_dat[3]}:${booking_dat[4]}" ]] && [[ ! "$time_to" > "${booking_dat[5]}:${booking_dat[6]}" ]]; then
        echo 6
        return
      elif [[ "$time_from" < "${booking_dat[3]}:${booking_dat[4]}" ]] && [[ "$time_to" > "${booking_dat[5]}:${booking_dat[6]}" ]]; then
        echo 7
        return
      fi
    fi
  done <<< "$booking_file"

  echo 0
}


# Task 4
## Book Venue
book_venue() {
  while true; do
    echo -e "Patron Details Validation"
    echo -e "$break_line $break_line"

    read -rp "Please enter the Patron's ID Number:" patron_id

    # Read from file to find the patron name
    patron_file=$(cat patron.txt)
    found=false
    while IFS= read -r line; do
      # Split patron.txt file by :
      IFS=':' read -ra patron_dat <<<"$line"
      # Check if patron id is equal to patron id in patron.txt file
      if [ "$patron_id" = "${patron_dat[0]}" ]; then
        echo -e "Patron Name: ${patron_dat[1]}"
        found=true
        patron_contact="${patron_dat[1]}"
        break
      fi
    done <<< "$patron_file"
    if [ "$found" = false ]; then
      clear
      echo -e "Patron ID not found"
      echo -e "$empty_line"
      continue
    else
      break
    fi
  done

  echo -e "$empty_line"

  while true; do
    read -rp "Press (n) to proceed Book Venue or (q) to return to University Venue Management Menu:" proceed_book_venue
    if [ "$proceed_book_venue" = "q" ] || [ "$proceed_book_venue" = "Q" ]; then
      clear
      return
    elif [ "$proceed_book_venue" = "n" ] || [ "$proceed_book_venue" = "N" ]; then
      break
    else
      # Delete previous two lines and print invalid input
      echo -e "\033[2A\033[KInvalid input"
    fi
  done

  clear
  
  while true; do
    echo -e "Booking Venue"
    echo -e "$break_line $break_line"

    read -rp "Please enter the Room Number:" room_number

    # Read venue.txt file
    venue_file=$(cat venue.txt)

    found=false
    not_available=false
    flag=0

    # Read from file to find the room number
    while IFS= read -r line; do
      # Split venue.txt file by :
      IFS=':' read -ra venue_dat <<<"$line"
      # Check if room number is equal to room number in venue.txt file
            
      if [ "$room_number" = "${venue_dat[1]}" ]; then
        found=true

        venue_status=$(echo ${venue_dat[5]} | tr -d '[:space:]')
        if [ "$venue_status" != "Available" ]; then
          not_available=true
          break
        fi
        
        echo -e "\nRoom Type: ${venue_dat[2]}"
        echo -e "Capacity: ${venue_dat[3]}"
        echo -e "Remarks: ${venue_dat[4]}"
        echo -e "Status: $venue_status"
        break
      fi
    done <<< "$venue_file"

    if [ "$found" = false ]; then
      clear
      echo -e "Room Number not found\n"
      continue
    elif [ "$not_available" = true ]; then
      clear
      echo -e "Room Number selected is not available\n"
      continue
    fi

    echo -e "\n$break_line"
    echo -e "Notes: The booking hours shall be from 8am to 8pm only. The booking duration shall be at least 30 minutes per booking. \n\n"

    echo -e "Please enter the following details: \n\n"
    read -rp "Booking Date (mm/dd/yyyy): " booking_date

    flag=$(check_booking_date "$booking_date")

    if([ "$flag" == "1" ]); then
      clear
      echo -e "Format of Booking Date is not valid\nPlease try again\n\n"
      continue
    elif([ "$flag" == "2" ]); then
      clear
      echo -e "Booking Date does not exist\nPlease try again\n\n"
      continue
    elif([ "$flag" == "3" ]); then
      clear
      echo -e "Booking Date must be tomorrow's date\nPlease try again\n\n"
      continue
    fi

    read -rp "Time From (24 Hour Format, hh:mm): " time_from

    flag=$(check_time_from "$room_number" "$booking_date" "$time_from")

    if([ "$flag" == "1" ]); then
      clear
      echo -e "Format of Time From is not valid\nPlease try again\n\n"
      continue
    elif([ "$flag" == "2" ]); then
      clear
      echo -e "Time From entered does not exist\nPlease try again\n\n"
      continue
    elif([ "$flag" == "3" ]); then
      clear
      echo -e "Time From is not within 08:00 to 19:30\nPlease try again\n\n"
      continue
    elif([ "$flag" == "4" ]); then
      clear
      echo -e "Time From clashes with another booking\nPlease try again\n\n"
      continue
    fi

    # Input time to
    read -rp "Time To (24 Hour Format, hh:mm): " time_to

    flag=$(check_time_to "$room_number" "$booking_date" "$time_from" "$time_to")

    if([ "$flag" == "1" ]); then
      clear
      echo -e "Format of Time To is not valid\nPlease try again\n\n"
      continue
    elif([ "$flag" == "2" ]); then
      clear
      echo -e "Time To entered does not exist\nPlease try again\n\n"
      continue
    elif([ "$flag" == "3" ]); then
      clear
      echo -e "Time To is not within 08:30 to 20:00\nPlease try again\n\n"
      continue
    elif([ "$flag" == "4" ]); then
      clear
      echo -e "Time To is not greater than Time From\nPlease try again\n\n"
      continue
    elif([ "$flag" == "5" ]); then
      clear
      echo -e "Duration must be at least 30 minutes\nPlease try again\n\n"
      continue
    elif([ "$flag" == "6" ]); then
      clear
      echo -e "Time To clashes with another booking\nPlease try again\n\n"
      continue
    elif([ "$flag" == "7" ]); then
      clear
      echo -e "Another booking within time booked\nPlease try again\n\n"
      continue
    fi

    break
  done

  read -rp "Reason of Booking: " reason_of_booking

  while true; do
    read -rp "Press (s) to save and generate the venue booking details or Press (c) to cancel the Venue Booking and return to University Venue Management Menu:" save_generate_venue_booking
    if [ "$save_generate_venue_booking" = "c" ] || [ "$save_generate_venue_booking" = "C" ] ; then
      return
    elif [ "$save_generate_venue_booking" = "s" ] || [ "$save_generate_venue_booking" = "S" ] ; then  
      # Save data to booking.txt file
      echo -e "$patron_id:$room_number:$booking_date:$time_from:$time_to:$reason_of_booking" >>booking.txt

      # replace booking date / with -
      filename_booking_date=$(echo "$booking_date" | tr '/' '-')

      filename="${patron_id}_${room_number}_${filename_booking_date}.txt"
      touch "$filename"

      echo -e "\t\t\tVenue Booking Receipt \n" >>"$filename"
      echo -e "Patron ID: $patron_id\t\t\tPatron Name: $patron_contact" >>"$filename"
      echo -e "Room Number: $room_number" >>"$filename"
      echo -e "Data Booking: $booking_date" >>"$filename"
      echo -e "Time From: $time_from\t\t\t\tTime To: $time_to" >>"$filename"
      echo -e "Reason of Booking: $reason_of_booking" >>"$filename"
      echo -e "\n\n\tThis is a computer generated receipt with no signature required\n" >>"$filename"
      return
    else
      clear
      echo -e "Invalid input\n\n"
    fi
  done
}

cont=true
while [ "$cont" == true ]; do
  main_menu
  # Switch case to execute the option
  case "$option" in
  "A" | "a")
    register_patron
    ;;
  "B" | "b")
    search_patron_details
    ;;
  "C" | "c")
    add_new_venue
    ;;
  "D" | "d")
    list_venue_details
    ;;
  "E" | "e")
    book_venue
    ;;
  "Q" | "q")
    exit
    ;;
  esac
done
