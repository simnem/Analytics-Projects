MENU = {
    "espresso": {
        "ingredients": {
            "water": 50,
            "coffee": 18,
        },
        "cost": 1.5,
    },
    "latte": {
        "ingredients": {
            "water": 200,
            "milk": 150,
            "coffee": 24,
        },
        "cost": 2.5,
    },
    "cappuccino": {
        "ingredients": {
            "water": 250,
            "milk": 100,
            "coffee": 24,
        },
        "cost": 3.0,
    }
}

resources = {
    "water": 300,
    "milk": 200,
    "coffee": 100,
}
money = 0.0


def ingredient_checker(choice1, missing_ing):
    """Goes through all needed ingredient for needed drink and checks if it could be made"""
    for option in MENU:
        if choice1 == option:
            for ing in MENU[option]["ingredients"]:
                for res in resources:
                    if ing == res and MENU[option]["ingredients"][ing] > resources[res]:
                        missing_ing.append(ing)
    return missing_ing


def coin_collector():
    """Calculates the total of coins inserted"""
    print("Please insert coins")
    quarters = int(input(" How many quarters: "))
    dimes = int(input(" How many dimes: "))
    nickles = int(input(" How many nickles: "))
    pennies = int(input(" How many pennies: "))
    total = quarters * 0.25 + dimes * 0.1 + nickles * 0.05 + pennies * 0.01
    return total


def coffee_maker(opt):
    """Adds the profits and subtracts used ingredients from overall resources"""
    global money
    money += opt["cost"]
    for res in resources:
        for ing in opt["ingredients"]:
            if res == ing:
                resources[res] -= opt["ingredients"][ing]


machine_on = True
while machine_on:
    # TODO 1. Prompt user by asking “What would you like? (espresso/latte/cappuccino):
    user_choice = input("What would you like to order? (espresso/latte/cappuccino): \n").lower()
    # TODO 2. Turn off the Coffee Machine by entering “off ” to the prompt.
    if user_choice == "off":
        machine_on = False
    # TODO 3. Print report.
    elif user_choice == "report":
        for ingredient in resources:
            unit = ""
            if ingredient in ["water", "milk"]:
                unit = "ml"
            else:
                unit = "g"
            print(f"{ingredient.title()}: {resources[ingredient]}{unit}")
        print(f"Money: ${money}")
    elif user_choice in ["espresso", "latte", "cappuccino"]:
        # TODO 4. Check resources sufficient?
        checker = []
        ingredient_checker(user_choice, checker)
        if checker:
            str_ing = ''
            for ing in checker:
                str_ing += ing + " "
            print(f"Sorry there is not enough {str_ing}.")
        else:
            # TODO 5. Process coins.
            total_coins = coin_collector()
            # TODO 6. Check transaction successful?
            if MENU[user_choice]["cost"] > total_coins:
                print("Sorry that's not enough money. Money refunded.")
            elif MENU[user_choice]["cost"] < total_coins:
                print(f'Here is ${total_coins - MENU[user_choice]["cost"]} dollars in change.')
                # TODO 7. Make Coffee.
                coffee_maker(MENU[user_choice])
                print(f"Here is your {user_choice}. Enjoy!")
            else:
                coffee_maker(MENU[user_choice])
                print(f"Here is your {user_choice}. Enjoy!")
    else:
        print("Please insert correct option")
