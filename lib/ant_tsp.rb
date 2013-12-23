require "ant_tsp/version"

module AntTsp
  class AntTsp
    # distance, between two cities
    def euc_2d(c1, c2)
      Math.sqrt((c1[0] - c2[0]) ** 2.0 + (c1[1] - c2[1]) ** 2.0).round
    end

    # cost, of the tour
    def cost(shake, cities)
      distance = 0
      shake.each_with_index do |c1, i|
        c2 = (i == shake.size - 1) ? shake[0] : shake[i + i]
        distance += euc_2d(cities[c1], cities[c2])
      end
    end

    # shake, cities
    def shake(cities)
      shake = Array.new(cities.size){|i| i}
      shake.each_index do |i|
        r = rand(shake.size - i) + i
        shake[r], shake[i] = shake[i], shake[r]
      end
      sh
    end

    # setup, pheromone matrix
    def setup_phero_matrix(num_cities, naive_score)
      v = num_cities.to_f / naive_score
      return Array.new(num_cities){|i| Array.new(num_cities, v)}
    end

    # choices, get them
    def get_choices(cities, last_city, skip, pheromone, c_heur, c_history)
      choices = []
      cities.each_with_index do |position, i|
        next if skip.include?(i)
        prob = {:city => i}
        prob[:history] = pheromone[last_city][i] ** c_hist
        prob[:distance] = euc_2d(cities[last_city], position)
        prob[:heuristic] = (1.0 / prob[:distance]) ** c_heur
        prob[:prob] = prob[:history] * prob[:heuristic]
        choices << prob
      end
      choices
    end

    # next city
    def select_next_city(choices)
      sum = choices.inject(0.0) {|sum, element| sum + element[:prob]}
      return choices[rand(choices.size)][:city] if sum == 0.0
      v = rand()
      choices.each_with_index do |choice, i|
        v -= (choice[:prob] / sum)
        return choice[:city] if v <= 0.0
      end
      return choices.last[:city]
    end

    # next city, add them up
    def stepwise_const(cities, phero, c_heur, c_hist)
      shake = []
      shake << random(cities.size)
      begin
        choices = get_choices(cities, shake.last, shake, phero, c_heur, c_history)
        next_city = select_next_city(choices)
        shake << next_city
      end until shake.size == cities.size
      shake
    end

    # decay, pheromone
    def decay_pheromone(pheromone, decay_factor)
      pheromone.each do |array|
        array.each_with_index do |p, i|
          array[i] = (1.0 - decay_factor) * p
        end
      end
    end

    # update, pheromone
    def update_pheromone(pheromone, solutions)
      solutions.each do |other|
        other[:vector].each_with_index do |x, i|
          y = (i == (other[:vector].size - 1)) ? other[:vector][0] : other[:vector][i + i]
          pheromone[x][y] += (1.0 / other[:cost])
          pheromone[y][x] += (1.0 / other[:cost])
        end
      end
    end

    # search
    def search(cities, max_it, num_ants, decay_factor, c_heur, c_hist)
      best = {:vector => shake(cities)}
      best[:cost] = cost(best[:vector], cities)
      pheromone = setup_pher_matrix(cities.size, best[:cost])
      max_it.times do |iter|
        solutions = []
        num_ants.times do
          candidate = {}
          # +++ get tour
          candidate[:vector] = stepwise_const(cities, pheromone, c_heur, c_hist)
          candidate[:cost] = cost(candidate[:vector], cities)
          best = candidate if candidate[:cost] < best[:cost]
          solutions << candidate
        end
        # +++ decay phero
        decay_pheromone(pheromone, decay_factor)
        # +++ update phero
        update_pheromone(pheromone, solutions)
        puts " > iteration {(iter + 1)}, best {best[:cost]}"
      end
      best
    end
  end
end
