package online_store_project.validator;

import lombok.Getter;
import java.util.*;

public class ValidatorResult {

    @Getter
    private final List<Errors> errors = new ArrayList<>();

    public void addError(Errors error) {
        errors.add(error);
    }


    public boolean isValid(){
        return errors.isEmpty();
    }



}
