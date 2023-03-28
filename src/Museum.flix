mod Museum {

    pub def visitMuseum(): Unit \ IO = 
        Entrance.buyTicket();
        Restaurant.buyMeal();
        Giftshop.buyGift()

}
