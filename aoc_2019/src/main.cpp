#include <SFML/Graphics.hpp>
#include <print>

int main()
{
	std::println("Hello, World!");

    return 0;
}

/*

    // SFML 3 uses a Vector2u for the window size
    sf::RenderWindow window(sf::VideoMode({800, 600}), "SFML 3 works!");
    sf::CircleShape shape(100.f);
    shape.setFillColor(sf::Color::Green);

    while (window.isOpen())
    {
        // The event loop is different in SFML 3
        // pollEvent now returns an optional
        while (const auto event = window.pollEvent())
        {
            if (event->is<sf::Event::Closed>())
            {
                window.close();
            }
        }

        window.clear();
        window.draw(shape);
        window.display();
    }


*/
