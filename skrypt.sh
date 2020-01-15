#!/bin/bash

# Dodawanie użytkownika
add_user() {
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "    DODAWANIE UŻYTKOWNIKA    "
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	if [ $(id -u) -eq 0 ]; # Sprawdzenie, czy uruchomiono jako root
	
	then
		read -p "Wprowadź nazwę użytkownika : " username
		read -s -p "Wprowadź hasło : " password 
		egrep "^$username" /etc/passwd >/dev/null # Sprawdzenie, czy istnieje już użytkownik o takiej nazwie
			if [ $? -eq 0 ]; then 
				echo "Nazwa użytkownika $username już istnieje! Wprowadź inną!"
				exit 1
			else
				pass=$(perl -e 'print crypt($ARGV[0], "password")' $password) # Szyfrowanie hasła
				useradd -m -p $pass $username # Utworzenie nowego użytkownika
				[ $? -eq 0 ] && echo "Nowy użytkownik został dodany do systemu!" || echo "Wystąpił błąd podczas dodawania użytkownika!"
			fi
	else
		echo "Tylko administrator może dodać nowego użytkownika."
		exit 2
	fi
}

# Wyświetlenie informacji o systemie
system_info() {
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "    INFORMACJE O SYSTEMIE    "
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

	user=$(whoami) # przypisanie do zmiennej $user wyjścia z komendy whoami
	echo "Zalogowany użytkownik: $user"
	echo "Katalog domowy: $HOME" # użycie zmiennej globalnej $HOME

	echo ""
	echo "Informacje o pamięci"
	echo "---------------------------------------------------"
	echo ""
	free -m
	echo ""
	echo "Przestrzeń na dysku"
	echo "---------------------------------------------------"
	echo ""
	df -h 
}

# Wyświetlenie daty
show_date() {
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "        DATA I GODZINA        "
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo ""
	Year=`date +%Y`
	Month=`date +%m`
	Day=`date +%d`
	Hour=`date +%H`
	Minute=`date +%M`

	echo "Data: $Day-$Month-$Year"
	echo "Godzina: $Hour:$Minute"
	echo ""
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}

# Wyświetlenie monitu, by powrócić do menu głównego
press_enter() {
	echo ""
	echo -n "Wciśnij klawisz Enter, aby powrócić do menu głównego..."
	read
	clear
}

# Obsługa błędu wprowadzenia opcji spoza dostępnych.
incorrect_selection() {
	echo "Ta opcja nie jest dostępna. Spróbuj ponownie."
}

until ["$selection" = "0"]; do
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "        MENU GŁÓWNE        "
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo ""
	echo "1 - Dodaj użytkownika"
	echo "2 - Informacje o systemie"
	echo "3 - Data i godzina"
	echo "0 - Wyjście"
	echo ""
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo -n "Wybierz opcję [0-3] > "
	read selection
	echo ""
	
	case $selection in
		1 ) clear ; add_user ; press_enter ;;
		2 ) clear ; system_info ; press_enter ;;
		3 ) clear ; show_date ; press_enter ;;
		0 ) clear ; exit ;;
		* ) clear ; incorrect_selection ; press_enter ;;
	esac
done
