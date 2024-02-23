library(shiny)
library(shinydashboard)
library(DT)
library(shinyjs)
library(rmarkdown)

shinyUI(dashboardPage(
  
  dashboardHeader(title = "Menu"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Wprowadzenie", tabName = "page1"),
      menuItem("Uzupełnienie danych", tabName = "page2"),
      menuItem("Analiza i podsumowanie", tabName = "page3"))),
  
  dashboardBody(
    tabItems(
      tabItem("page1",
              fluidPage(
                h1("Analiza wartości klientów: korepetycje"),
                h2("Wstęp↓"),
                sidebarLayout(
                  sidebarPanel(
                    h3("Projekt umożliwia przeprowadzenie szybkiej analizy wartości poszczególnych klientów. Ma to sens jedynie w gałęziach biznesu, w których mamy doczynienia ze stałymi klientami. My jednak skupimy się jedynie na korepetycjach. Projekt składa się z aplikacji shiny oraz z prezentacji.→")
                  ),
                  mainPanel(
                    h3("Projekt składa się z trzech stron. Opiera się na przeprowadzeniu krótkiej analizy wprowadzanych przez ciebie rekordów ze zmiennymi: Imie, CenaZaGodz, IloscLekcji, DataPierwszejLekcji. Na obecnej znaduje się wstęp w którym poznajesz założenia projektu oraz obeznasz się z obsługą instrukcji kolejnych stron. Na drugiej stronie w jej lewej części znajduje się panel, w którym należy uzupełnić dane dotyczące danego ucznia, potem naciśnąć przycisk zatwierdź. W prawej części strony w panelu głównym wyświetli się wtedy zatwierdzony rekord. Operację należy powtórzyć ze wszystkimi uczniami. Możesz wtedy przejść do następnej strony, gdzie zobaczysz prostą analizę podanych przez siebie wyników oraz wyciągnąć z ich trafne wnioski.")
                )
              )
      )),
      tabItem("page2",
              fluidPage(
                h2("Wprowadzanie danych"),
                sidebarLayout(
                  sidebarPanel(
                    textInput("imie", "Imię:"),
                    numericInput("cena", "Cena za godzinę:", value = 0),
                    numericInput("iloscLekcji", "Ilość lekcji:", value = 0),
                    dateInput("dataPierwszejLekcji", "Data pierwszej lekcji:", value = Sys.Date()),
                    actionButton("zatwierdzButton", "Zatwierdź"),
                    actionButton("cofnijButton", "Cofnij"),
                    actionButton("resetButton", "Zresetuj")
                  ),
                  mainPanel(
                    dataTableOutput("dane")
                  )
                )
              )
      ),
      tabItem("page3",
              fluidPage(
                h2("Analiza"),
                h4("Na początek pokażę kilka podstawowych statystyk dla rozkładu ceny:"),
                verbatimTextOutput("stats"),
                h4("Zobaczmy jak będzie wyglądał wykres pudełkowy tego rozkładu"),
                plotOutput("boxplot", height = "200px"),
                h4("Możemy zobaczyć, że wyliczona mediana pokrywa się z tą na wykresie, możemy również odczytać ile wynosi pierwszy i trzeci kwartyl. Sprawdźmy jak będzie wyglądał wykres przychodów podzielony na poszczególnych uczniów."),
                verbatimTextOutput("przychod"),
                plotOutput("histogram1", height = "300px"),
                h4("Okej widzimy jak wygląda przychód na ucznia, ale weźmy teraz pod uwagę datę pierwszej lekcji i obliczmy, ile dany uczeń zapewnia \"dziennie\" przychodu (dni od momentu pierwszej lekcji do dziś)."),
                plotOutput("histogram2", height = "300px"),
                h4("Mam nadzieję, że powyższa analiza na coś Ci się przydała i możesz wyciągnąć z niej jakieś sensowne wnioski odnośnie wartości twoich klientów. Jak będziesz mnie znowu potrzebować to wiesz gdzie szukać!!!")
              )
)))))

