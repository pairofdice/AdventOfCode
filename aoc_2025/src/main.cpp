#include <SFML/Graphics.hpp>
#include <fstream>
#include <iostream>
#include <print>

void day_01();
int main() {
	std::print("Advent of Code 2025");
	day_01();
	return 0;
}

struct Instruction {
	char direction;
	int distance;
};

std::vector<Instruction> read_instructions_from_file(const std::string& filename) {
	std::ifstream file(filename);

	if (!file.is_open()) {
		std::cerr << "Error: could not open file " << filename << "\n";
		return {};
	}
	std::vector<Instruction> instructions;
	std::string line;

	while (std::getline(file, line)) {
		if (line.empty()) continue;
		Instruction inst;

		inst.direction = line[0];

		try {
			inst.distance = std::stoi(line.substr(1));
		} catch (const std::exception& e) {
			std::cerr << "Warning: Failed to parse distance from line: " << line << "\n";
			continue;
		}
		instructions.push_back(inst);
	}
	return instructions;
}

int countZeros(int dial, int rotations) {
	int result { 0 };
	while (rotations > 0) {
		--rotations;
		++dial;
		if (dial == 100) dial = 0;
		if (dial == 0) ++result;
	}
	while (rotations < 0) {
		++rotations;
		--dial;
		if (dial == -1) dial = 99;
		if (dial == 0) ++result;
	}
	return result;
}

void day_01() {
	std::println(" day 01!");
	auto data = read_instructions_from_file("data/01.txt");
	int dial { 50 };
	int countZero { 0 };

	for (Instruction i : data) {
		if (i.direction == 'L') {
			dial -= i.distance;
		} else {
			dial += i.distance;
		}
		dial %= 100;

		while (dial < 0) dial += 100;
		if (dial == 0) ++countZero;
	}
	std::println("Part 1: countZero: {}", countZero);
	// part 2, reset
	dial = 50;
	countZero = 0;
	for (Instruction i : data) {
		if (i.direction == 'L') {
			countZero += countZeros(dial, -i.distance);
			dial -= i.distance;
		} else {
			countZero += countZeros(dial, i.distance);
			dial += i.distance;
		}

		while (dial > 99) dial -= 100;
		while (dial < 0) dial += 100;
	}
	std::println("Part 2: countZero: {}", countZero);
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
