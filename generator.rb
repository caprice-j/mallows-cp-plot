
# all explanatory variables
# exps = ["hp[mB]","mpg[mB]","disp[mB]", "wgt[mB]", "lux[mB]", "pcp[mB]", "suv[mB]", "spt[mB]", "awd[mB]", "hybrid[mB]", "fourspd[mB]"]
exps = ["var1","var2","var3"]
# a response variable
resp = "resp"

print "unbiased_sigma_sqhat = "
print "sum( lsfit( cbind( #{exps.join(' ,')} ), #{resp} )$residual^2 )"
print " / ( length( #{resp} ) - " + (exps.length+1).to_s + " )\n"
                                    # plus one? why?

def cp_output n, exps, resp
  enumrator = exps.combination(n)
  all_combis = enumrator.collect { |variable| variable.join(', ') }

  all_combis.each_with_index{ | combi, idx |
    print "rss_#{n}#{idx} = "
    print "sum( lsfit( cbind( #{combi} ), #{resp} )$residual^2 ) \n"

    print " cp_#{n}#{idx} = "
    print "( rss_#{n}#{idx} / "
    print "unbiased_sigma_sqhat ) - ( length( #{resp} ) - 2 * #{n+1} )\n"
  }

  return ncr exps.length, n
end

def ncr n, r
  count = 0
  arr = Array.new(n)
  arr.combination(r){ |i| count += 1 }
  return count
end

n_combinations = []
for r in 1 .. exps.length do
  num = cp_output r, exps, resp
  n_combinations.push( num )
end

print 'cp_criteria = c( '
      for r in 1 .. exps.length do
        n_combinations[r-1].times do |j|
          if r != exps.length || n_combinations[r-1] != j+1 then
            print "cp_#{r}#{j}, "
          else
            print "cp_#{r}#{j}"
          end
        end
      end
print " ) \n"

print 'n_variables = c( '
 for r in 1 .. exps.length do
        n_combinations[r-1].times do |j|
          if r != exps.length || n_combinations[r-1] != j+1 then
            print "#{r}, "
          else
            print "#{r}"
          end
        end
      end
print " ) \n"


print "plot(n_variables, cp_criteria, "
print "xlab='n_variables, p (including constant)', ylab='Cp values' )\n"
print "abline( 0, 1)\n"

puts "## copy, paste, and execute the above code in R"
