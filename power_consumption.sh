#!/bin/bash

echo ""
echo -e "\033[0;31m
PLEASE NOTE THAT THIS SCRIPT WILL CALCULATE THE MONTHLY COST BASED ON THE PROVIDED POWER CONSUMPTION.
INTEGER OR NUMBER WITH THE POINT ONLY! ES. 21 OR 21.4
\033[0m"
echo ""

# Watt consumption
###################################################################################################

# Regex to exclude all except for " 0-9 and . " from the variable
pattern='^[0-9]+([.][0-9]+)?$'

# Check if the number provided is good
while true; do
  read -p "Enter the watts: " w
  if [[ $w =~ $pattern ]]; then
    break
  else
    echo "Invalid input. Please enter a number."
  fi
done

result_w=$(echo "scale=4; $w / 1000" | bc -l)

if (( $(echo "$result_w < 1" | bc -l) )); then
    result_w="0$result_w"
fi

echo "Kilowatts: $result_w"

###################################################################################################

# Kw in 24 hours
# Check if the number provided is good
while true; do
  read -p "Hours of uptime in a day: " uptime
  if [[ $uptime =~ $pattern ]]; then
    break
  else
    echo "Invalid input. Please enter a number."
  fi
done

result_kw24=$(echo $result_w \* $uptime | bc)

if (( $(echo "$result_kw24 < 1" | bc -l) )); then
    result_kw24="0$result_kw24"
fi
echo "Kw/24h: $result_kw24"

###################################################################################################

# Kw in 365 days
result_kw365=$(echo $result_kw24 \* 365 | bc)

if (( $(echo "$result_kw365 < 1" | bc -l) )); then
    result_kw365="0$result_kw365"
fi
echo "Kw/year: $result_kw365"

###################################################################################################

# € in one month
# Check if the number provided is good
while true; do
    read -p "Price of kw/h? " kw_hour
  if [[ $kw_hour =~ $pattern ]]; then
    break
  else
    echo "Invalid input. Please enter a number."
  fi
done

kw_costs_365=$(echo "scale=2; ($kw_hour * $result_kw365 + 0.005) / 1" | bc)

if (( $(echo "$kw_costs_365 < 1" | bc -l) )); then
    kw_costs_365="0$kw_costs_365"
fi
echo "€/year: $kw_costs_365"

###################################################################################################

# € in one year
euro_month=$(echo "scale=2; $kw_costs_365 / 12" | bc -l)

if (( $(echo "$euro_month < 1" | bc -l) )); then
    euro_month="0$euro_month"
fi
echo "€/month: $euro_month"