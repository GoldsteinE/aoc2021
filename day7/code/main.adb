with ada.text_io;
with ada.containers.vectors;
with ada.integer_text_io;
with ada.command_line;
use ada.text_io;
use ada.command_line;

procedure main is
	package integer_vectors is new
		ada.containers.vectors (index_type => natural, element_type => integer);
	use integer_vectors;

	package sorting is new integer_vectors.generic_sorting;

	line : string := get_line;
	part : string := argument(1);
	val : integer;
	res : integer := 2147483647;
	tmp : integer;
	total : integer;
	last : positive := 1;
	nums : vector;
begin
	while last <= line'last loop
		ada.integer_text_io.get(line(last..line'last), val, last);
		nums.append(val);
		last := last + 2;
	end loop;

	sorting.sort(nums);
	val := nums.first_element;
	while val <= nums.last_element loop
		total := 0;
		for elem of nums loop
			if part = "1" then
				total := total + abs (elem - val);
			else
				tmp := abs (elem - val);
				total := total + (tmp * (tmp + 1) / 2);
			end if;
		end loop;
		if total < res then
			res := total;
		end if;
		val := val + 1;
	end loop;

	ada.integer_text_io.put(res, width => 1);
end main;

-- neomake: skip
