function fish_prompt
  set -l last_status $status
  # Use delta for prompt if clear, epsilon if error
  set -l stat
  if test $last_status -eq 0
    set stat (set_color brwhite)\u03B4(set_color normal)
  else
    set stat (set_color red)\u03B5(set_color normal)
  end

  echo (set_color brgreen)(whoami) (set_color brblue)(prompt_pwd)(set_color normal)
  echo \u2514 $stat ''
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
