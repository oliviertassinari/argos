import { forwardRef, useId } from "react";
import { useFormContext } from "react-hook-form";

import { FormError } from "./FormError";
import { FormLabel } from "./FormLabel";
import { TextInput, TextInputProps } from "./TextInput";

type FormTextInputProps = {
  name: string;
  label: string;
  hiddenLabel?: boolean;
} & TextInputProps;

export const FormTextInput = forwardRef<HTMLInputElement, FormTextInputProps>(
  (
    { label, id: idProp, hiddenLabel = false, name, disabled, ...props },
    ref
  ) => {
    const form = useFormContext();
    const { isSubmitting } = form.formState;
    const error = form.getFieldState(name)?.error;
    const genId = useId();
    const id = idProp || genId;
    const invalid = Boolean(error);
    return (
      <div>
        {!hiddenLabel && (
          <FormLabel htmlFor={id} invalid={invalid}>
            {label}
          </FormLabel>
        )}
        <TextInput
          ref={ref}
          id={id}
          name={name}
          aria-invalid={invalid ? "true" : undefined}
          aria-label={hiddenLabel ? label : undefined}
          disabled={disabled || isSubmitting}
          {...props}
        />
        {error?.message && (
          <FormError className="mt-2">{error.message}</FormError>
        )}
      </div>
    );
  }
);
