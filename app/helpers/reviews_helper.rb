module ReviewsHelper
  
  def satisfaction_degree_options
    satisfaction_options = []
    satisfaction_degree_value_r = 1.0r
    until satisfaction_degree_value_r > 5.0r || satisfaction_options.size == 100
      satisfaction_options << satisfaction_degree_value_r
      satisfaction_degree_value_r += 0.1r
    end
    satisfaction_options.map {|n| n.to_f }
  end
  
end
