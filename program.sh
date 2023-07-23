#!/bin/bash

# Common Variables
break_line="----------------------------------------"
empty_line="\n"

# Task 1:
## Print main menu
main_menu() {
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

check_patron_id() {

  patron_id=$1
  if [ -z "$patron_id" ]; then
    echo 2
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
}

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
      echo -e "Patron ID already exist \nPlease try again\n\n"
      continue
    elif [ "$flag" == 2 ]; then
      clear
      echo -e "Patron ID cannot be empty \nPlease try again\n\n"
      continue
    fi

    read -rp "Patron Full Name (As per NRIC):" patron_full_name
    # Patron Full Name Validation
    flag=$(check_patron_name "$patron_full_name")
    if [ "$flag" == "1" ]; then
      clear
      echo -e "Patron Name should only contains alphabets\nPlease try again\n\n"
      continue
      #elif [ "$flag" == "2" ]; then
      # clear
      # echo -e "Patron Name cannot be empty\nPlease try again\n\n"
      # continue
    fi

    read -rp "Contact Number:" patron_contact_number
    # Patron Contact Number Validation
    flag=$(check_patron_contact "$patron_contact_number")
    if [ "$flag" == "1" ]; then
      clear
      echo -e "Patron Contact Number should only contains number and + - symbol\nPlease try again\n\n"
      continue
    elif [ "$flag" == "2" ]; then
      clear
      echo -e "Patron Contact Number cannot be empty\nPlease try again\n\n"
      continue
    fi

    read -rp "Email Address:" patron_email_address
    # Patron Email Address Validation
    flag=$(check_patron_email "$patron_email_address")
    if [ "$flag" == "1" ]; then
      clear
      echo -e "Patron Email Address is not valid\nPlease try again\n\n"
      continue
    elif [ "$flag" == "2" ]; then
      clear
      echo -e "Patron Email Address cannot be empty\nPlease try again\n\n"
      continue
    fi
    echo -e "$empty_line"

    write_patron "$patron_id" "$patron_full_name" "$patron_contact_number" "$patron_email_address"

    read -rp "Register Another Patron? (y) es or (q)uit:" register_another_patron
    if [ "$register_another_patron" = "q" ]; then
      break
    fi
    clear
  done
}

## Search Patron Details
search_patron_details() {
  while true; do
    echo -e "Search Patron Details"
    read -rp "Enter Patron ID:" patron_id
    echo -e "$break_line"

    # Read patron.txt file
    patron_file=$(cat patron.txt)
    # Split patron.txt file by new line
    # Loop through patron.txt file
    for line in $patron_file; do
      # Split patron.txt file by :
      IFS=':' read -ra patron_dat <<<"$line"
      # Check if patron id is equal to patron id in patron.txt file
      if [ "$patron_id" = "${patron_dat[0]}" ]; then
        echo -e "Patron Full Name: ${patron_dat[1]}"
        echo -e "Contact Number: ${patron_dat[2]}"
        echo -e "Email Address: ${patron_dat[3]}"
        echo -e "$break_line"
        break
      else
        echo -e "Patron ID not found"
      fi
    done

    read -rp "Search Another Patron? (y) es or (q)uit:" search_another_patron
    if [ "$search_another_patron" = "q" ]; then
      break
    fi
    clear
  done
}

# Task 3
## Add new venue
add_new_venue() {
  while true; do
    echo -e "Add New Venue\n"
    echo -e "$break_line $break_line"

    read -rp "Block Name:" block_name
    read -rp "Room Number:" room_number
    read -rp "Room Type:" room_type
    read -rp "Capacity:" capacity
    read -rp "Remarks:" remarks
    read -rp "Status (by default):" status

    echo -e "\n$block_name:$room_number:$room_type:$capacity:$remarks:$status" >>venue.txt
    read -rp "Add Another Venue? (y) es or (q)uit:" add_another_venue
    if [ "$add_another_venue" = "q" ]; then
      break
    fi
    clear
  done
}

## List Venue Details
list_venue_details() {
  while true; do
    echo -e "List Venue Details"
    read -rp "Enter Block name:" block_name
    echo -e "$break_line"

    # Read venue.txt file
    venue_file=$(cat venue.txt)
    # Print Table Header
    echo -e "Room Number \t\tRoom Type \tCapacity \tRemarks \tStatus"
    # Split venue.txt file by new line
    # Loop through venue.txt file
    for line in $venue_file; do
      # Split venue.txt file by :
      IFS=':' read -ra venue_dat <<<"$line"
      # Check if block name is equal to block name in venue.txt file
      if [ "$block_name" = "${venue_dat[0]}" ]; then
        echo -e "${venue_dat[1]} \t\t\t${venue_dat[2]} \t\t${venue_dat[3]} \t\t${venue_dat[4]} \t\t${venue_dat[5]}"
      fi
    done
    read -rp "Search Another Block Venue? (y) es or (q)uit:" search_another_venue
    if [ "$search_another_venue" = "q" ]; then
      break
    fi
    clear
  done
}

# Task 4
## Book Venue
book_venue() {
  echo -e "Patron Details Validation"
  echo -e "$break_line $break_line"
  read -rp "Please enter the Patron's ID Number:" patron_id

  # Read from file to find the patron name
  for line in $patron_file; do
    # Split patron.txt file by :
    IFS=':' read -ra patron_dat <<<"$line"
    # Check if patron id is equal to patron id in patron.txt file
    if [ "$patron_id" = "${patron_dat[0]}" ]; then
      echo -e "Patron Name: ${patron_dat[1]}"
      patron_contact="${patron_dat[1]}"
      break
    fi
  done

  read -rp "Press (n) to proceed Book Venue or (q) to return to University Venue Management Menu:" proceed_book_venue
  if [ "$proceed_book_venue" = "q" ]; then
    return
  fi

  echo -e "Booking Venue"
  echo -e "$break_line $break_line"
  read -rp "Please enter the Room Number:" room_number

  # Read from file to find the room number
  for line in $venue_file; do
    # Split venue.txt file by :
    IFS=':' read -ra venue_dat <<<"$line"
    # Check if room number is equal to room number in venue.txt file
    if [ "$room_number" = "${venue_dat[1]}" ]; then
      echo -e "Room Type: ${venue_dat[2]}"
      echo -e "Capacity: ${venue_dat[3]}"
      echo -e "Remarks: ${venue_dat[4]}"
      echo -e "Status: ${venue_dat[5]}"
      break
    fi
  done

  echo -e "$break_line"
  echo -e "Notes: The booking hours shall be from 8am to 8pm only. The booking duration shall be at least 30 minutes per booking. \n\n"

  echo -e "Please enter the following details: \n\n"
  read -rp "Booking Date (mm-dd-yyyy):" booking_date
  read -rp "Time From (hh:mm):" time_from
  read -rp "Time To (hh:mm):" time_to
  read -rp "Reason of Booking:" reason_of_booking

  read -rp "Press (s) to save and generate the venue booking details or Press (c) to cancel the Venue Booking and return to University Venue Management Menu:" save_generate_venue_booking
  if [ "$save_generate_venue_booking" = "c" ]; then
    exit
  fi

  # Save data to booking.txt file
  echo -e "$patron_id:$room_number:$booking_date:$time_from:$time_to:$reason_of_booking" >>booking.txt

  clear

  filename="${patron_id}_${room_number}_${booking_date}.txt"
  touch "$filename"
  echo -e "Venue Booking Details \n\n" >>"$filename"
  echo -e "Patron ID: $patron_id \t\t\t\t Patron Name: $patron_contact" >>"$filename"
  echo -e "Room Number: $room_number" >>"$filename"
  echo -e "Data Booking: $booking_date" >>"$filename"
  echo -e "Time From: $time_from \t\t\t\t Time To: $time_to" >>"$filename"
  echo -e "Reason of Booking: $reason_of_booking" >>"$filename"
  echo -e "\n\n \t\t This is a computer generated receipt with no signature required" >>"$filename"
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
