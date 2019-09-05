defmodule Nookal.Appointment do
  import Nookal.Utils

  @type t() :: %__MODULE__{
          id: integer(),
          patient_id: integer(),
          date: Date.t(),
          start_time: NaiveDateTime.t(),
          end_time: NaiveDateTime.t(),
          location_id: integer(),
          type: String.t(),
          type_id: integer(),
          practitioner_id: integer(),
          email_reminder_sent?: integer(),
          arrived?: integer(),
          cancelled?: integer(),
          invoice_generated?: integer(),
          cancellation_date: Date.t(),
          notes: String.t(),
          date_created: NaiveDateTime.t(),
          date_modified: NaiveDateTime.t()
        }

  defstruct [
    :id,
    :patient_id,
    :date,
    :start_time,
    :end_time,
    :location_id,
    :type,
    :type_id,
    :practitioner_id,
    :email_reminder_sent?,
    :arrived?,
    :cancelled?,
    :invoice_generated?,
    :cancellation_date,
    :notes,
    :date_created,
    :date_modified
  ]

  @mapping [
    {:id, "ID", :integer},
    {:patient_id, "patientID", :integer},
    {:date, "appointmentDate", :date},
    {:start_time, "appointmentStartTime", :naive_date_time},
    {:end_time, "appointmentEndTime", :naive_date_time},
    {:location_id, "locationID", :integer},
    {:type, "appointmentType", :string},
    {:type_id, "appointmentTypeID", :integer},
    {:practitioner_id, "practitionerID", :integer},
    {:email_reminder_sent?, "emailReminderSent", :integer},
    {:arrived?, "arrived", :integer},
    {:cancelled?, "cancelled", :integer},
    {:invoice_generated?, "invoiceGenerated", :integer},
    {:cancellation_date, "cancellationDate", :date},
    {:notes, "Notes", :string},
    {:date_created, "dateCreated", :naive_date_time},
    {:date_modified, "lastModified", :naive_date_time}
  ]

  def new(payload) when is_list(payload) do
    all_or_none_map(payload, &new/1)
  end

  def new(payload) do
    with {:ok, appointment} <- extract_fields(@mapping, payload, %__MODULE__{}),
         {:ok, appointment} <- get_appointment_current_month(appointment) do
      {:ok, appointment}
    end
  end

  def get_appointment_current_month(appointment) do
    current_month = Date.utc_today().month
    month = appointment.date.month

    case current_month == month do
      true -> {:ok, appointment}
    end
  end
end
